import { ref } from 'vue';
import { defineStore } from 'pinia';
import { formatApt } from '@/utils/format';
import { useAptosStore } from './aptos';

export const useUserStore = defineStore('user', () => {
  const aptosStore = useAptosStore();
  const userInfo = ref(); // 用户信息
  const balance = ref(0); // 账户余额

  function setUserInfo(val: any) {
    userInfo.value = val;
  }

  function setBalance(val: number) {
    balance.value = val;
  }

  /**
   * 获取账户余额
   * @returns
   */
  function getBalance() {
    return new Promise(async (resolve, reject) => {
      const client = aptosStore.getAptosClient();
      console.log('getBalance ==>', aptosStore.account?.address, client, aptosStore.token);
      if (!aptosStore.account?.address || !client || !aptosStore.token) {
        reject(0);
        return;
      }
      try {
        const accountResources: any = await client.getAccountResource(
          aptosStore.account?.address,
          '0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>',
        );
        console.log('getAccountResource ==>', accountResources);
        const coin = accountResources?.data?.coin?.value;
        balance.value = formatApt(coin);
        resolve(balance.value);
      } catch (error) {
        reject(error);
        console.log('getBalance failed', error);
      }
    });
  }

  return {
    userInfo,
    setUserInfo,
    balance,
    getBalance,
    setBalance,
  };
});
