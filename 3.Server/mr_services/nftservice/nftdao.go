package nftservice

import (
	"context"
	"fmt"
	"github.com/aureontu/MRWebServer/mr_services/mpb"
	"time"

	com "github.com/aureontu/MRWebServer/mr_services/common"
	"github.com/aureontu/MRWebServer/mr_services/mpberr"
	"github.com/oldjon/gutil/gdb"
	grmux "github.com/oldjon/gutil/redismutex"
	"go.uber.org/zap"
)

type nftDAO struct {
	svc    *NFTService
	logger *zap.Logger
	rMux   *grmux.RedisMutex
	nftDB  *gdb.DB
	tmpDB  *gdb.DB
	rm     *NFTResourceMgr
}

func newNftDAO(svc *NFTService, rMux *grmux.RedisMutex, nftRedis, tmpRedis gdb.RedisClient) *nftDAO {
	return &nftDAO{
		logger: svc.logger,
		rMux:   rMux,
		nftDB:  gdb.NewDB(nftRedis),
		tmpDB:  gdb.NewDB(tmpRedis),
		rm:     svc.rm,
	}
}

func (dao *nftDAO) checkGraphiLimit(ctx context.Context, addr string) (bool, error) {
	ok, err := dao.tmpDB.SetEXNX(ctx, com.NFTGraphiLimitKey(addr), 0, time.Second*time.Duration(dao.rm.getGraphiQLQueryLimitSecs()))
	if err != nil {
		dao.logger.Error("checkGraphiLimit failed", zap.Error(err))
		return false, mpberr.ErrDB
	}
	return ok, nil
}

func (dao *nftDAO) getGraphiQLQueryStartIndex(ctx context.Context, addr string) (uint64, error) {
	index, err := gdb.ToUint64(dao.nftDB.Get(ctx, com.NFTGraphiStartIndexKey(addr)))
	if err != nil && !dao.nftDB.IsErrNil(err) {
		dao.logger.Error("getGraphiQLQueryStartIndex failed", zap.Error(err))
		return 0, mpberr.ErrDB
	}
	return index, nil
}

func (dao *nftDAO) setGraphiQLQueryStartIndex(ctx context.Context, addr string, cnt int64) error {
	_, err := dao.nftDB.IncrBy(ctx, com.NFTGraphiStartIndexKey(addr), cnt)
	if err != nil {
		dao.logger.Error("setGraphiQLQueryStartIndex failed", zap.Error(err))
		return mpberr.ErrDB
	}
	return nil
}

func (dao *nftDAO) updateNFTs(ctx context.Context, userId uint64, addNFTs map[string]*mpb.AptosNFTNodeV2,
	delNFTs map[string]bool) error {
	key := com.NFTsKey(userId)
	anyMap := make(map[string]any)
	anyList := make([]any, 0, len(addNFTs)*2)
	for k, v := range addNFTs {
		nft := dao.svc.AptosNFTNodeV22DBAptosNFTNodeV2(v)
		anyMap[k] = nft
		anyList = append(anyList, uint64(nft.TokenId)<<32|uint64(nft.TransactionTimestampInt), nft.TokenDataId)
	}
	delFields := make([]string, 0, len(delNFTs))
	delAnyList := make([]any, 0, len(delNFTs))
	for k := range delNFTs {
		delFields = append(delFields, k)
		delAnyList = append(delAnyList, k)
	}
	fmt.Println(addNFTs)
	err := dao.rMux.Safely(ctx, key, func() error {
		var err error
		if len(anyMap) > 0 {
			_, err = dao.nftDB.ZAdd(ctx, com.NFTsListKey(userId), anyList...)
			if err != nil {
				dao.logger.Error("updateNFTs ZAdd failed", zap.Uint64("user_id", userId),
					zap.Any("add_nfts", addNFTs), zap.Any("del_nfts", delNFTs), zap.Error(err))
				return err
			}
			err = dao.nftDB.HSetObjects(ctx, key, anyMap)
			if err != nil {
				dao.logger.Error("updateNFTs HSetObjects failed", zap.Uint64("user_id", userId),
					zap.Any("add_nfts", addNFTs), zap.Any("del_nfts", delNFTs), zap.Error(err))
				return err
			}
		}
		if len(delFields) > 0 {
			_, err = dao.nftDB.ZRem(ctx, com.NFTsListKey(userId), delAnyList...)
			if err != nil {
				dao.logger.Error("updateNFTs ZRem failed", zap.Uint64("user_id", userId),
					zap.Any("add_nfts", addNFTs), zap.Any("del_nfts", delNFTs), zap.Error(err))
				return err
			}
			_, err = dao.nftDB.HDel(ctx, key, delFields...)
			if err != nil {
				dao.logger.Error("updateNFTs HDel failed", zap.Uint64("user_id", userId),
					zap.Any("add_nfts", addNFTs), zap.Any("del_nfts", delNFTs), zap.Error(err))
				return err
			}
		}
		return nil
	})
	if err != nil {
		dao.logger.Error("updateNFTs safely failed", zap.Uint64("user_id", userId),
			zap.Any("add_nfts", addNFTs), zap.Any("del_nfts", delNFTs), zap.Error(err))
		return err
	}
	return nil
}

func (dao *nftDAO) getNFTs(ctx context.Context, userId uint64) ([]*mpb.DBAptosNFTNodeV2, error) {
	fields, err := dao.nftDB.ZRange(ctx, com.NFTsListKey(userId), 0, -1)
	if err != nil {
		dao.logger.Error("getNFTs ZRange failed", zap.Uint64("user_id", userId), zap.Error(err))
		return nil, err
	}
	if len(fields) == 0 {
		return nil, nil
	}
	nfts := make([]*mpb.DBAptosNFTNodeV2, len(fields))
	err = dao.nftDB.HMGetObjects(ctx, com.NFTsKey(userId), fields, &nfts)
	if err != nil {
		dao.logger.Error("getNFTs HGetAllObjects failed", zap.Uint64("user_id", userId), zap.Error(err))
		return nil, err
	}
	return nfts, nil
}
