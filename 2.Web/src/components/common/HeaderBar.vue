<template>
  <div class="header-bar">
    <img class="bg" :src="getAssetsUrl('headbar_bg.png')" alt="" />
    <div>
      <div class="logo" v-if="showLogo">
        <a :href="indexUrl" aria-label="Mirror Realms">
          <img :src="getImgUrl('mr-logo-white.png')" alt="" />
        </a>
      </div>
    </div>

    <div class="tools">
      <span
        v-for="(nav, index) in navList"
        :key="index"
        class="tools-item"
        :class="{ active: nav.activeKey === pathName }"
        @click="goPage(nav.url, nav.isOut)"
        >{{ nav.label }}</span
      >

      <!-- 登陆 -->
      <span @click="callLogin" class="tools-item" v-if="!connected || !token">
        <img :src="getAssetsUrl('login.png')" alt="" />
        Login</span
      >
      <n-popover trigger="click" v-else>
        <template #trigger>
          <span class="tools-item"
            ><img :src="getAssetsUrl('login.png')" alt="" />{{
              formatAddress(account?.address || '')
            }}</span
          >
        </template>

        <div class="user-tools-list">
          <div class="item" @click="goPage('/my-collection')">Collection</div>
          <div class="item" @click="goPage('/setting')">Setting</div>
        </div>
      </n-popover>
    </div>
  </div>

  <Login ref="loginRef" @login="onLogin" />
  <BindEmail ref="bindEmailRef" @bind="onBind" />
</template>

<script lang="ts" setup>
import { ref, computed } from 'vue';
import { useUserStore } from '@/stores/user';
import { useAptosStore } from '@/stores/aptos';
import { useRouter } from 'vue-router';
import { storeToRefs } from 'pinia';
import { NPopover } from 'naive-ui';

import Login from '@/components/common/Login.vue';
import BindEmail from '@/components/common/BindEmail.vue';
import config from '@/config';
import { getEnv, getIndexUrl, getAssetsUrl, getImgUrl } from '@/utils';
import { formatAddress } from '@/utils/format';

const store = useUserStore();
const { userInfo } = storeToRefs(store);
const aptosStore = useAptosStore();
const { account, connected, token } = storeToRefs(aptosStore);
const router = useRouter();

defineProps({
  showLogo: {
    type: Boolean,
    default: false,
  },
});

const env = getEnv();
const indexUrl = getIndexUrl(env);

const navList = [
  // { label: 'World View', activeKey: 'world-view', isOut: false, url: '/world-view' },
  // { label: 'PFPs', activeKey: 'pfps', isOut: false, url: '/pfps' },
  { label: 'Marketplace', activeKey: 'market-place', isOut: false, url: '/market-place' },
  {
    label: 'WhitePaper',
    activeKey: 'white-paper',
    isOut: true,
    url: config.headerBar.whitePaperUrl,
  },
];

const pathName = computed(() => {
  const pathNames = location.pathname?.split('/')?.filter(Boolean) || [];
  const lastPathName = pathNames[pathNames.length - 1];
  return lastPathName;
});

/** 登陆 */
const loginRef = ref();
const bindEmailRef = ref();

function callLogin() {
  loginRef.value.open();
}

function onLogin() {
  loginRef.value.close();
  if (!userInfo.value?.email) {
    bindEmailRef.value.open();
  }
}

function onBind() {
  bindEmailRef.value.close();
}

function goPage(url: string, isOut: boolean = false) {
  console.log('goPage');
  if (isOut) {
    window.open(url, '_blank');
    return;
  }
  router.push(url);
}
</script>

<style scoped lang="scss">
.header-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 148px;
  z-index: 100;
  // background: url('../../assets/img/headbar_bg.png') no-repeat 0 0;
  // backdrop-filter: blur(10.88px);

  .bg {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    z-index: -1;
  }
}

.logo {
  width: 200px;
  margin-left: 53px;
  margin-top: -10px;

  img {
    width: 100%;
  }
}

.tools {
  display: flex;
  justify-content: flex-end;
  font-size: 16px;
  margin-right: 61px;
  margin-top: -20px;
}

.tools-item {
  display: flex;
  align-items: center;
  margin-left: 80px;
  color: #fff;
  font-size: 24px;
  line-height: 29px;
  cursor: pointer;

  img {
    width: 25px;
    margin-right: 9.5px;
  }

  &.active {
    color: #1ceaee;
    font-weight: bold;
  }
}

.user-tools-list {
  font-size: 20px;
  .item {
    padding: 10px 10px;
    cursor: pointer;
  }
}
</style>
