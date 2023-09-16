package main

import (
	"github.com/aureontu/MRWebServer/mr_services/httpgateway"
	"github.com/aureontu/MRWebServer/mr_services/nftservice"
	"log"
	"math/rand"
	"time"

	"github.com/aureontu/MRWebServer/mr_services/accountservice"
	"github.com/aureontu/MRWebServer/mr_services/apiproxy"
	gxcom "github.com/oldjon/gx/common"
	gxgrpc "github.com/oldjon/gx/modules/grpc"
	gxhttp "github.com/oldjon/gx/modules/http"
	"github.com/oldjon/gx/service"
)

func init() {
	rand.Seed(time.Now().UnixNano())

	gxcom.SetSnowflakeClusterID(1) // set 1 by default, may use in the future
	gxcom.SetSnowflakeClusterBits(3)
}

func main() {
	host, err := service.
		SetupModule(
			gxhttp.New(httpgateway.NewHTTPGateway),
			service.WithModuleName("httpgateway"),
			service.WithRole("httpgateway"),
		).
		SetupModule(
			gxgrpc.New(accountservice.NewAccountService),
			service.WithModuleName("accountservice"),
			service.WithRole("accountservice"),
		).
		SetupModule(
			gxhttp.New(apiproxy.NewAPIProxy),
			service.WithModuleName("apiproxy"),
			service.WithRole("apiproxy"),
		).
		SetupModule( // apiproxygrpc must be setup with apiproxy
			gxgrpc.New(apiproxy.NewAPIProxyGRPCService),
			service.WithModuleName("apiproxygrpc"),
			service.WithRole("apiproxy"),
		).
		SetupModule(
			gxgrpc.New(nftservice.NewNFTService),
			service.WithModuleName("nftservice"),
			service.WithRole("nftservice"),
		).
		Build()
	if err != nil {
		log.Fatalf("build service failed: %v", err)
	}

	if err := host.Serve(); err != nil {
		log.Printf("serve service failed: %v", err)
	}
}
