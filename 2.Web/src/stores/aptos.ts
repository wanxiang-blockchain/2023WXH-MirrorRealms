import { ref } from 'vue';
import { defineStore } from 'pinia';
import { AptosClient } from 'aptos';
import { useUserStore } from './user';
import * as api from '@/api/petra';
import { message } from '@/utils';
import { useLocalCache } from '@/utils/storage';
import { networkUrl as networkUrlConfig } from '@/config/aptos/networkUrl';

import { NetworkType, NewNetWorkType, AccountType, SignType, AptosErrorType } from '@/types';

export const useAptosStore = defineStore('aptos', () => {
  const userStore = useUserStore();
  const { setCache, getCache, removeCache } = useLocalCache();

  const isPetraInstalled = ref(false); // petra插件是否安装
  const connected = ref(false); // 钱包是否连接
  const connecting = ref(false); // 连接中
  const network = ref<NetworkType>('Mainnet'); // 网络
  const networkUrl = ref('');
  const account = ref<AccountType>();
  const token = ref(getCache('Authorization'));
  const changeFlag = ref(false);
  const aptosWalletName = getCache('AptosWalletName');

  isPetraInstalled.value = window.aptos;

  function getPetraWallet(goInstall = true) {
    if (isPetraInstalled.value) {
      return window.aptos;
    } else {
      if (goInstall) {
        window.open('https://petra.app/', `_blank`);
      }
      return null;
    }
  }

  /**
   * 连接petra钱包
   * @returns
   */
  function connect(isInit = false): Promise<AccountType> {
    return new Promise(async (resolve, reject) => {
      const wallet = getPetraWallet(!isInit);
      console.log('connect use wallet ==>', wallet);
      if (!wallet) {
        reject(null);
        return;
      }
      try {
        connecting.value = true;
        const _account = await wallet.connect();
        console.log('connect success ==>', _account);
        connecting.value = false;

        // 用户在别的地方切换了账户
        if (_account.address !== getCache('AccountAddress')) {
          clearToken();
        }

        account.value = _account;
        connected.value = true;
        setCache('AptosWalletName', 'Petra');
        setCache('AccountAddress', _account.address);
        resolve(_account);
      } catch (error: any) {
        connecting.value = false;
        handleError('connect', error);
        reject(null);
      }
    });
  }

  /**
   * 钱包签名
   */
  function sign(): Promise<SignType> {
    return new Promise(async (resolve, reject) => {
      const wallet = getPetraWallet();
      if (!wallet) {
        reject(null);
        return;
      }
      if (!connected.value) {
        await connect();
      }
      try {
        const nonce = await getNonce();
        const res = await wallet.signMessage({
          message: nonce,
          nonce: nonce,
        });
        console.log('sign success ==>', res);
        resolve(res);
      } catch (error: any) {
        handleError('sign', error);
        reject(error);
      }
    });
  }

  /**
   * 验证签名，并获取用户信息及token
   */
  function verify(signInfo: SignType): Promise<any> {
    return new Promise(async (resolve, reject) => {
      const wallet = getPetraWallet();
      if (!wallet) {
        reject(null);
        return;
      }

      try {
        const res = await api.webLoginByWallet({
          wallet_addr: signInfo.address,
          pub_key: account.value?.publicKey || '',
          aptos_full_msg: signInfo.fullMessage,
          aptos_signature: signInfo.signature,
        });
        console.log('verify success ==>', res);
        resolve(res);
      } catch (error: any) {
        handleError('verify', error);
        reject(error);
      }
    });
  }

  /**
   * 签名并更新token
   * @param callback 回调函数，可用于钱包4100状态，重签名后，执行原有功能
   */
  function signAndVerify(callback?: any) {
    return new Promise(async (resolve, reject) => {
      try {
        const signRes = await sign();
        const verifyRes: any = await verify(signRes);
        // 本地保存token
        if (verifyRes.token) {
          const bearerToken = `Bearer ${verifyRes.token}`;
          setCache('Authorization', bearerToken);
          // 响应式更行token，使得HeaderBar中的状态更新
          token.value = bearerToken;
        }
        // 缓存用户信息
        userStore.setUserInfo(verifyRes.account || null);
        userStore.getBalance();

        resolve(null);

        // 回调函数
        if (callback) callback();
      } catch (error) {
        console.log('signAndVerify failed ==>', error);
        reject(error);
      }
    });
  }

  function handleError(action: string, error: AptosErrorType) {
    console.log(`${action} failed ==>`, error);
    switch (error.code) {
      case 4000:
        message.error('No accounts found');
        break;
      case 4001:
        // do nothing
        break;
      case 4100:
        // sign();
        break;
      default:
        break;
    }
  }

  /**
   * 初始化petra钱包
   * 1. 检查是否存在钱包插件
   * 2. 连接钱包
   * 3. 获取network信息
   * 4. 监听network和account变化
   * 5. 监听disconnect
   * @returns
   */
  async function initPetraWallet(autoConnect = true) {
    console.log('call initPetraWallet!!!');
    if (!isPetraInstalled.value) return;
    const wallet = getPetraWallet();

    try {
      // 获取network
      const currentNetwork: NewNetWorkType = await wallet.getNetwork();
      console.log('current network ==>', currentNetwork.name);
      network.value = currentNetwork.name;
      networkUrl.value = networkUrlConfig[currentNetwork.name];
      console.log(autoConnect, aptosWalletName);
      if (autoConnect && aptosWalletName === 'Petra') {
        await connect(true);
      } else {
        return;
      }

      // 监听network切换
      wallet.onNetworkChange((newNetwork: any) => {
        // 避免监听函数重复触发
        console.log(changeFlag.value);
        if (changeFlag.value) return;
        changeFlag.value = true;
        setTimeout(() => {
          changeFlag.value = false;
        }, 200);

        console.log('network change ==>', newNetwork);
        network.value = newNetwork.name;
        networkUrl.value = networkUrlConfig[newNetwork.name as 'Testnet' | 'Mainnet'];
      });

      // 监听account切换
      wallet.onAccountChange(async (newAccount: any) => {
        // 避免监听函数重复触发
        console.log(changeFlag.value);
        if (changeFlag.value) return;
        changeFlag.value = true;
        setTimeout(() => {
          changeFlag.value = false;
        }, 200);

        console.log('account change ==>', newAccount);
        // If the new account has already connected to your app then the newAccount will be returned
        if (newAccount) {
          account.value = newAccount;
        } else {
          // Otherwise you will need to ask to connect to the new account
          await connect();
        }
        clearToken();
        userStore.setBalance(0);
        connected.value = false;
      });

      // 监听disconnect
      wallet.onDisconnect(() => {
        // 避免监听函数重复触发
        console.log(changeFlag.value);
        if (changeFlag.value) return;
        changeFlag.value = true;
        setTimeout(() => {
          changeFlag.value = false;
        }, 200);

        console.log('disconnect ==>');
      });

      console.log('initPetraWallet success!!!!!');
    } catch (error) {
      console.log('initPetraWallet error', error);
    }
  }

  async function logout() {
    try {
      // const wallet = getPetraWallet();
      // await wallet.disconnect();
      connected.value = false;
      account.value = { address: '', publicKey: '' };
      clearToken();
    } catch (error) {
      console.log('logout failed', error);
    }
  }

  function clearToken() {
    removeCache('Authorization');
    token.value = '';
  }

  /**
   * 获取aptos客户端
   * @returns
   */
  function getAptosClient() {
    console.log('getAptosClient', networkUrl.value);
    if (!networkUrl.value) return null;
    return new AptosClient(networkUrl.value);
  }

  /**
   * 获取nonce
   */
  function getNonce() {
    return new Promise(async (resolve, reject) => {
      try {
        const res = await api.getNonce();
        resolve(res.nonce);
      } catch (error) {
        console.log('getNonce failed', error);
        reject(error);
      }
    });
  }

  return {
    getNonce,
    isPetraInstalled,
    getPetraWallet,
    initPetraWallet,
    connect,
    connected,
    networkUrl,
    network,
    account,
    signAndVerify,
    token,
    getAptosClient,
    logout,
    clearToken,
  };
});
