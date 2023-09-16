<template>
  <TheModal
    class="summon-weapon-modal-wrapper"
    :visible="visible"
    :width="1000"
    padding="60px"
    @close="close"
  >
    <div class="title">Summon Weapon</div>

    <div class="content">
      <div class="left">
        <div class="title">Selected Weapon</div>
        <div class="selected-weapon">
          <WeaponSelectItem :detail="selectedWeapon" :active="true" />
        </div>

        <div class="confirm-wrapper">
          <n-checkbox v-model:checked="checked">
            Summon a new weapon will burn the old NFT you selected.
          </n-checkbox>
          <n-button
            class="confirm-btn"
            :loading="loading"
            :disabled="!checked || !selectedId || !chosonWeaponId"
            :color="checked && selectedId && chosonWeaponId ? '#1CEAEE' : '#d8d8d8'"
            @click="summonWeapon"
            >Confirm</n-button
          >
        </div>
      </div>

      <div class="plus">+</div>

      <div class="right">
        <div class="title">Choose another weapon</div>
        <WeaponSelectItem
          v-for="item in restWeaponList"
          :key="item.token_name"
          :detail="item"
          :active="item.token_name === chosonWeaponId"
          @select="onSelectWeapon"
        />
      </div>
    </div>
  </TheModal>
</template>

<script lang="ts" setup>
import { ref, nextTick, computed } from 'vue';
import { NButton, NCheckbox } from 'naive-ui';
import { find } from 'lodash-es';

import TheModal from '../components/common/TheModal.vue';
import WeaponSelectItem from './components/WeaponSelectItem.vue';

import { useNftsStore } from '@/stores/nfts';

const emit = defineEmits(['onSummon']);

const props = defineProps({
  weaponList: {
    type: Array,
    default: () => [],
  },
});

const nftsStore = useNftsStore();

const visible = ref(false);
const loading = ref(false);
const chosonWeaponId = ref('');
const checked = ref(false);
const selectedId = ref('');

/**
 * 选中的武器
 */
const selectedWeapon: any = computed(() => {
  return find(props.weaponList, { token_name: selectedId.value }) || null;
});

const restWeaponList: any = computed(() => {
  return props.weaponList?.filter((o: any) => o.token_name !== selectedId.value);
});

function open(_data: any) {
  visible.value = true;
  selectedId.value = _data.selectedId;
  console.log(selectedId.value);
}

function close() {
  if (loading.value) return;
  visible.value = false;
}

function onSelectWeapon(detail: any) {
  chosonWeaponId.value = detail?.token_name;
}

async function summonWeapon() {
  try {
    loading.value = true;
    const res = await nftsStore.summon([selectedId.value, chosonWeaponId.value]);
    console.log(res);
    visible.value = false;
    await nextTick();
    emit('onSummon', res);
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
.summon-weapon-modal-wrapper {
  color: #313131;

  .title {
    margin-bottom: 35px;
    font-size: 36px;
    font-weight: bold;
  }

  .content {
    display: flex;
    justify-content: space-between;

    .title {
      margin-bottom: 22px;
      font-size: 18px;
      line-height: 24px;
    }

    .selected-weapon {
      margin-bottom: 127px;
    }

    .left {
      width: 480px;
    }

    .right {
      width: 480px;
      height: 430px;
      overflow-y: auto;

      &::-webkit-scrollbar {
        display: none;
      }
    }
  }

  .plus {
    margin: 60px 0;
    font-size: 64px;
    font-weight: bold;
    color: #1ceaee;
  }

  .confirm-btn {
    width: 328px;
    height: 57px;
    margin-top: 20px;
    border-radius: 8px;
    font-size: 24px;
    color: #000;
  }
}
</style>
