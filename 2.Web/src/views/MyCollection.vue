<template>
  <HeaderBar show-logo />
  <div class="page-wrapper">
    <BackGround :bg-url="getImgUrl('bgnormal.png', 'orig')" />

    <div class="page-content">
      <div class="title">My Collection</div>

      <div class="tabs">
        <div
          class="tab"
          :class="{ active: activeTab === item.value }"
          v-for="item in tabList"
          :key="item.value"
          @click="activeTab = item.value"
        >
          {{ item.label }}
        </div>
      </div>

      <n-spin :show="loading">
        <div class="weapon-list">
          <WeaponItem
            v-for="(item, index) in weaponList"
            :key="index"
            :detail="item"
            :img-size="175"
            @summon="callSummon"
          />
        </div>
      </n-spin>
    </div>
  </div>

  <SummonWeaponModal ref="SummonWeaponModalRef" :weapon-list="weaponList" @on-summon="onSummon" />
  <PurchaseModal ref="PurchaseModalRef" :show-purchase="false" @close="onPurchaseClose" />
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue';
import { NSpin } from 'naive-ui';
import HeaderBar from '../components/common/HeaderBar.vue';
import BackGround from '@/components/common/BackGround.vue';
import WeaponItem from '@/components/components/WeaponItem.vue';
import SummonWeaponModal from '@/components/SummonWeaponModal.vue';
import PurchaseModal from '@/components/PurchaseModal.vue';

import { getImgUrl } from '@/utils';
import * as api from '@/api/nfts';

const weaponList = ref<any>([]);
const tabList = ref([{ label: 'Weapon', value: 'weapon' }]);
const activeTab = ref('weapon');
const SummonWeaponModalRef = ref();
const PurchaseModalRef = ref();
const loading = ref(false);

onMounted(() => {
  getAptosNFTsV2();
});

async function getAptosNFTsV2() {
  try {
    loading.value = true;
    const res = await api.getAptosNFTsV2({});
    weaponList.value = res.nfts || [];
  } finally {
    loading.value = false;
  }
}

function callSummon(detail: any) {
  SummonWeaponModalRef.value.open({ selectedId: detail?.token_name });
}

function onSummon(detail: any) {
  PurchaseModalRef.value.open(detail);
}

function onPurchaseClose() {
  getAptosNFTsV2();
}
</script>

<style lang="scss" scoped>
.page-content {
  color: #fff;
  padding: 200px 180px 0 !important;

  .title {
    font-size: 48px;
    font-weight: bold;
    margin-bottom: 60px;
  }

  .tabs {
    display: flex;
    padding-bottom: 23px;
    margin-bottom: 33px;
    border-bottom: 1px solid #fff;

    .tab {
      width: 122px;
      height: 44px;
      font-size: 24px;
      border-radius: 16px;
      text-align: center;
      line-height: 40px;
      border: 1px solid #fff;
      color: #fff;
      transition: all 0.15s;
      cursor: pointer;

      &.active {
        background-color: #fff;
        color: #000;
      }
    }
  }

  .weapon-list {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    height: 500px;
    overflow-y: auto;

    &::-webkit-scrollbar {
      display: none;
    }
  }
}
</style>
