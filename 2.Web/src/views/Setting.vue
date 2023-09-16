<template>
  <HeaderBar show-logo />
  <div class="page-wrapper text-thin">
    <BackGround :bg-url="getImgUrl('bgnormal.png', 'orig')" />

    <div class="page-content">
      <div class="title">Setting</div>

      <div class="user-setting">
        <div class="item">
          <img :src="getAssetsUrl('icon_petra.jpg')" alt="" />
          <div class="value">{{ formatAddress(account?.address || '') }}</div>
        </div>
        <div class="item">
          <img :src="getAssetsUrl('icon_email.png')" alt="" />
          <div class="value" v-if="userInfo?.email">{{ userInfo?.email }}</div>
          <n-button class="text-btn" text color="#5266FF" v-else @click="bindEmail">
            Bind email
          </n-button>
        </div>
        <div class="item">
          <img :src="getAssetsUrl('icon_lock.png')" alt="" />
          <div class="value">********</div>
          <n-button class="text-btn" text color="#5266FF">Change</n-button>
        </div>

        <n-divider />
        <div>
          <n-button class="logout-btn" text color="#3D3D3D" @click="logout">Logout</n-button>
        </div>
      </div>
    </div>
  </div>

  <BindEmail ref="bindEmailRef" @bind="onBind" />
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { storeToRefs } from 'pinia';
import { NButton, NDivider } from 'naive-ui';
import { useUserStore } from '@/stores/user';
import { useAptosStore } from '@/stores/aptos';
import HeaderBar from '../components/common/HeaderBar.vue';
import BackGround from '@/components/common/BackGround.vue';
import BindEmail from '@/components/common/BindEmail.vue';

import { getImgUrl, getAssetsUrl } from '@/utils';
import { formatAddress } from '@/utils/format';

const router = useRouter();

const bindEmailRef = ref();

const store = useUserStore();
const { userInfo } = storeToRefs(store);
const aptosStore = useAptosStore();
const { account } = storeToRefs(aptosStore);

function bindEmail() {
  bindEmailRef.value.open();
}

function onBind() {
  bindEmailRef.value.close();
}

function logout() {
  aptosStore.logout();
  router.push('/');
}
</script>

<style lang="scss" scoped>
.page-content {
  padding: 200px 120px 0 !important;

  .title {
    font-size: 48px;
    font-weight: bold;
    margin-bottom: 50px;
    color: #fff;
  }

  .user-setting {
    // width: 1448px;
    height: 557px;
    padding: 60px 120px;
    border-radius: 20px;
    background-color: #fff;

    .item {
      display: flex;
      align-items: center;
      width: 100%;
      margin-bottom: 60px;

      .value {
        margin-left: 30px;
        font-size: 36px;
      }

      img {
        width: 80px;
        height: 80px;
      }

      .text-btn {
        margin-left: 50px;
        font-size: 36px;
      }
    }

    .item:nth-child(2),
    .item:nth-child(3) {
      img {
        width: 65px;
        height: 65px;
      }
    }
    .item:nth-child(3) {
      margin-bottom: 50px;
    }

    .logout-btn {
      font-size: 36px;
    }
  }
}
</style>
