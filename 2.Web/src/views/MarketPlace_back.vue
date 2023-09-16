<template>
  <div class="market-place">
    <BackGround :bg-url="getImgUrl('bgnft.png')" />
    <MarketPlaceHeaderBar :address="state.address" @login="userLogin" />

    <div class="test-info">{{ state.testInfo }}</div>

    <div class="test-btns">
      <n-button type="primary" @click="buyOrdinaryBlindBox">buyOrdinaryBlindBox</n-button>
      <n-button type="primary" @click="openOrdinaryBlindBox">openOrdinaryBlindBox</n-button>
      <n-button type="primary" @click="getOrdinaryCards">getOrdinaryCards</n-button>
      <n-button type="primary" @click="symbol">symbol</n-button>
    </div>
  </div>
</template>
<script lang="ts" setup>
import { onMounted, reactive } from 'vue';
import Web3 from 'web3';
import BackGround from '@/components/common/BackGround.vue';
import MarketPlaceHeaderBar from '@/components/common/MarketPlaceHeaderBar.vue';
import { getImgUrl } from '@/utils';
import config from '@/config';
import * as api from '@/api/marketplace';

let dApp: any = null;
let web3 = window.web3;

const state = reactive({
  testInfo: '',
  address: '',
});

const signNonce = (address: string, nonce: string) => {
  const hexData = web3.utils.utf8ToHex(nonce);
  web3.eth.personal.sign(hexData, address, async function (result: any, signature: any) {
    // console.log('签名结果', result, signature);
    // if (result) {
    //   state.testInfo = `签名失败，错误码：${result.code}，原因：${result.message}`;
    //   return;
    // }
    // state.testInfo = `签名成功，signature：${signature}`;
    // const { data } = await api.validate({ pktAddr: address, sign: signature });
    // console.log(data);
    // state.address = address;
    // startApp();
  });
};

const checkWeb3Env = () => {
  if (typeof web3 !== 'undefined') {
    console.log('检测web3成功');
    web3 = new Web3(web3.currentProvider);
    console.log(web3.currentProvider);
    if (web3.currentProvider.isMetaMask) {
      state.testInfo = '检测web3环境成功，当前通信服务提供对象：MetaMask';
    }
    return true;
  } else {
    console.log('未检测到metamask');
    state.testInfo = '未检测到web3环境';
    return false;
  }
};

const connectMetamask = () => {
  window.ethereum
    .request({ method: 'eth_requestAccounts' })
    .then(async (result: any) => {
      // const address = result[0];
      // console.log('钱包连接成功', result);
      // state.testInfo = `钱包连接成功，钱包地址：${address}`;
      // const { data } = await api.getnonce({ pktAddr: address });
      // console.log(data);
      // signNonce(address, data);
    })
    .catch((error: any) => {
      console.log('error', error);
      state.testInfo = `钱包连接失败，错误码：${error.code}，原因：${error.message}`;
    });
};

const startApp = () => {
  // const abi = config.marketPlace.abi;
  // const ylAddress = config.marketPlace.ylAddress;
  // dApp = new web3.eth.Contract(abi, ylAddress);
};

const userLogin = () => {
  const web3Res = checkWeb3Env();
  if (web3Res) {
    connectMetamask();
  }
};

const buyOrdinaryBlindBox = () => {
  dApp.methods.buyOrdinaryBlindBox(1).call((err: any, result: any) => {
    if (err) {
      console.log(err);
      return;
    }
    console.log(JSON.stringify(result));
  });
};

const openOrdinaryBlindBox = () => {
  dApp.methods.openOrdinaryBlindBox().call((err: any, result: any) => {
    if (err) {
      console.log(err);
      return;
    }
    console.log(JSON.stringify(result));
  });
};

const getOrdinaryCards = () => {
  dApp.methods.getOrdinaryCards().call((err: any, result: any) => {
    if (err) {
      console.log(err);
      return;
    }
    console.log(JSON.stringify(result));
  });
};

const symbol = () => {
  dApp.methods.symbol().call((err: any, result: any) => {
    if (err) {
      console.log(err);
      return;
    }
    console.log(JSON.stringify(result));
  });
};

onMounted(() => {
  checkWeb3Env();
});
</script>
<style lang="scss" scoped>
.test-info {
  margin-top: 300px;
  font-size: 30px;
  color: #fff;
  text-align: center;
  padding: 0 200px;
  white-space: break-spaces;
  word-break: break-all;
}

.test-btns {
  display: flex;
  flex-wrap: wrap;
  padding: 100px 200px;

  button + button {
    margin-left: 40px;
  }
}
</style>
