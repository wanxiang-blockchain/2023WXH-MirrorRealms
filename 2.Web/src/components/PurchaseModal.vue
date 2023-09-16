<template>
  <TheModal
    class="purchase-modal-wrapper"
    :visible="visible"
    :width="680"
    padding="40px 80px"
    @close="close"
  >
    <div class="title">Congratulations</div>

    <!-- 武器信息 -->
    <WeaponBox :detail="data" />

    <div class="purchase-wrapper" v-if="showPurchase">
      <n-button class="purchase-btn" :loading="loading" color="#1CEAEE" @click="purchase"
        >Purchase one more</n-button
      >
    </div>
  </TheModal>
</template>

<script lang="ts" setup>
import { ref, nextTick } from 'vue';
import { NButton } from 'naive-ui';

import TheModal from '../components/common/TheModal.vue';
import WeaponBox from './components/WeaponBox.vue';

import { useNftsStore } from '@/stores/nfts';

defineProps({
  showPurchase: {
    type: Boolean,
    default: true,
  },
});

const emit = defineEmits(['onPurchase', 'close']);

const nftsStore = useNftsStore();

const visible = ref(false);
const loading = ref(false);
const data = ref(null);

function open(_data: any) {
  visible.value = true;
  loading.value = false;
  console.log('open PurchaseModal ==>', _data);
  data.value = _data || null;
}

function close() {
  if (loading.value) return;
  visible.value = false;
  emit('close');
}

async function purchase() {
  try {
    loading.value = true;
    const res = await nftsStore.purchase();
    visible.value = false;
    await nextTick();
    emit('onPurchase', res);
  } finally {
    loading.value = false;
  }
}

defineExpose({
  open,
  close,
});
</script>

<style scoped lang="scss">
.purchase-modal-wrapper {
  color: #313131;

  .title {
    margin-bottom: 70px;
    font-size: 36px;
    font-weight: bold;
    text-align: center;
  }

  .purchase-wrapper {
    margin-top: 50px;
    text-align: center;
  }

  .purchase-btn {
    margin: 0 auto;
    width: 493px;
    height: 63px;
    border-radius: 8px;
    font-size: 24px;
    font-weight: bold;
    line-height: 26px;
    color: #000000;
  }
}
</style>
