<script setup lang="ts">
import { onMounted } from 'vue';
import { RouterView } from 'vue-router';
import { NConfigProvider } from 'naive-ui';
import { useAptosStore } from '@/stores/aptos';

const aptosStore = useAptosStore();

onMounted(() => {
  console.log('APP init');
  aptosStore.initPetraWallet();
});

const themeOverrides = {
  common: {
    primaryColor: '#1CEAEE',
    primaryColorHover: '#1CEAEE',
    primaryColorPressed: '#cda710',
    primaryColorSuppl: '#1CEAEE',
  },
};
</script>

<template>
  <n-config-provider :theme-overrides="themeOverrides">
    <RouterView />
  </n-config-provider>
</template>

<style></style>
