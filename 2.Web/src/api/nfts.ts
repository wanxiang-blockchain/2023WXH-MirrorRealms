import http from './request';
import { CReqGetAptosNFTs, CResGetAptosNFTsV2 } from './nfts.d';

/**
 * 获取nfts
 * @param data
 * @returns
 */
export const getAptosNFTs = (data: any) => {
  return http.post<any[]>('/mrbev1/GetAptosNFTs', data);
};

/**
 * 获取nft列表
 * @param data
 * @returns
 */
export const getAptosNFTsV2 = (data: any) => {
  return http.post<CResGetAptosNFTsV2>('/mrbev1/GetAptosNFTsV2', data);
};
