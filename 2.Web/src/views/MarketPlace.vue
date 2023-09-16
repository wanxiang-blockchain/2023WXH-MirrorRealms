<template>
  <HeaderBar show-logo />
  <div class="swiper-page">
    <BackGround :bg-url="getImgUrl('bgnormal.png', 'orig')" />
    <div class="swiper-page-content">
      <div class="page-content">
        <div class="title">Weapon NFT is selling !</div>
        <div class="box-info">
          <img :src="getImgUrl('weaponnft.png')" alt="" />
          <div class="cost">{{ cost }} APT</div>
          <div class="left-num">My APT：{{ np.round(balance, 4) }} Left</div>
        </div>

        <n-button class="purchase-btn" :loading="loading" color="#1CEAEE" @click="purchase"
          >Purchase</n-button
        >
      </div>
    </div>
  </div>

  <PurchaseModal ref="PurchaseModalRef" @on-purchase="onPurchase" />
</template>

<script lang="ts" setup>
import { ref, watch, onMounted } from 'vue';
import { storeToRefs } from 'pinia';
import { NButton } from 'naive-ui';
import np from 'number-precision';
import HeaderBar from '../components/common/HeaderBar.vue';
import BackGround from '@/components/common/BackGround.vue';
import PurchaseModal from '@/components/PurchaseModal.vue';
import { useUserStore } from '@/stores/user';
import { useAptosStore } from '@/stores/aptos';
import { useNftsStore } from '@/stores/nfts';
import { getImgUrl } from '@/utils';

const userStore = useUserStore();
const { balance } = storeToRefs(userStore);
const aptosStore = useAptosStore();
const { connected, networkUrl } = storeToRefs(aptosStore);
const nftsStore = useNftsStore();

const cost = ref('0.2');
const loading = ref(false);
const PurchaseModalRef = ref();

watch(
  () => networkUrl.value,
  (newNetworkUrl) => {
    console.log('watch networkUrl', newNetworkUrl);
    if (newNetworkUrl) {
      userStore.getBalance();
    }
  },
);
watch(
  () => connected.value,
  (newConnected) => {
    console.log('watch connected', newConnected);
    if (newConnected && networkUrl.value) {
      userStore.getBalance();
    }
  },
);

onMounted(() => {
  if (networkUrl.value && connected.value) {
    userStore.getBalance();
  }
});

async function purchase() {
  try {
    loading.value = true;
    const res = await nftsStore.purchase();
    PurchaseModalRef.value.open(res);
    userStore.getBalance();
  } finally {
    loading.value = false;
  }
}

function onPurchase(res: any) {
  PurchaseModalRef.value.open(res);
  userStore.getBalance();
}
</script>

<style lang="scss" scoped>
.page-content {
  text-align: center;
  color: #fff;

  .title {
    font-size: 48px;
    font-weight: bold;
    text-align: center;
    margin: 0 auto;
    margin-bottom: 94px;
  }

  .box-info {
    width: 250px;
    margin: 0 auto;
    margin-bottom: 25px;

    img {
      width: 100%;
      height: 250px;
      margin-bottom: 27px;
    }

    .cost {
      height: 45px;
      font-size: 36px;
      font-weight: bold;
      line-height: 29px;
    }

    .left-num {
      height: 29px;
      font-size: 18px;
      line-height: 29px;
    }
  }

  .purchase-btn {
    width: 493px;
    height: 63px;
    margin: 0 auto;
    border-radius: 8px;
    font-size: 24px;
    font-weight: bold;
    color: #000;
  }
}
</style>
@/config/aptos/transaction
