<template>
  <TheModal :visible="visible" :width="651" padding="97px 79px 101px 79px" @close="close">
    <div class="login-modal-wrapper">
      <div class="logo">
        <img :src="getAssetsUrl('petra_logo.png')" alt="" />
      </div>
      <div class="submit-wrapper">
        <n-button class="petra-btn" :loading="loading" color="#FF5F5F" @click="doConnect"
          >Login width Petra</n-button
        >
      </div>
    </div>
  </TheModal>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import { NButton } from 'naive-ui';
import { useAptosStore } from '@/stores/aptos';
import { storeToRefs } from 'pinia';
import TheModal from './TheModal.vue';
import { getAssetsUrl } from '@/utils';

const aptosStore = useAptosStore();
const { connected } = storeToRefs(aptosStore);

const emit = defineEmits(['login']);

const visible = ref(false);
const loading = ref(false);

function open() {
  visible.value = true;
}

function close() {
  if (loading.value) return;
  visible.value = false;
}

defineExpose({
  open,
  close,
});

/**
 * 连接petra钱包
 */
async function doConnect() {
  loading.value = true;
  try {
    if (!connected.value) {
      await aptosStore.connect();
    }
    await aptosStore.signAndVerify();
    loading.value = false;
    emit('login');
  } catch (error) {
    loading.value = false;
  }
}
</script>

<style scoped lang="scss">
.login-modal-wrapper {
  color: #313131;

  .logo {
    width: 122px;
    height: 122px;
    margin: 0 auto;
    margin-bottom: 111px;

    img {
      width: 100%;
    }
  }

  .submit-wrapper {
    margin: 0 auto;
    text-align: center;
  }

  .petra-btn {
    width: 493px;
    height: 77px;
    border-radius: 8px;
    font-size: 24px;
  }
}
</style>
