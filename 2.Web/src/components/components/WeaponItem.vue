<template>
  <div class="weapon-box-wrapper">
    <div class="weapon-img">
      <img :src="detail?.token_uri" alt="" />
    </div>
    <div class="info text-thin">
      <div class="name-block">
        <div class="name">{{ properties?.weapon_type }}</div>
        <div class="code">{{ weaponNo }}</div>
      </div>

      <div class="block quality">
        <div class="label">Quality</div>
        <div class="progress">
          <n-progress
            type="line"
            :percentage="Number(properties?.quality) || 0"
            :height="18"
            :border-radius="4"
            :fill-border-radius="0"
            rail-color="#fff"
            rail-style="border:1px solid #ccc"
            :color="getWeapenQualityColor(Number(properties?.quality) || 0)"
            :show-indicator="false"
          />
          <span class="percentage">{{ properties?.quality }}</span>
        </div>
      </div>

      <div class="footer">
        <div class="footer-item">
          <div class="label">Props</div>
          <div class="info">{{ properties?.prop1 }}</div>
          <div class="info">{{ properties?.prop2 }}</div>
        </div>

        <div class="footer-item">
          <div class="label">Owner</div>
          <div class="info">{{ formatAddress(account?.address || '') }}</div>
          <div class="info">{{ dayjs(detail.transaction_timestamp).format('YYYY-MM') }}</div>
        </div>
      </div>
    </div>

    <n-button class="summon-btn" color="#1CEAEE" @click="callSummon(detail)">Summon</n-button>
  </div>
</template>
<script lang="ts" setup>
import { computed, watch } from 'vue';
import { storeToRefs } from 'pinia';
import dayjs from 'dayjs';
import { NProgress, NButton } from 'naive-ui';
import { getWeapenQualityColor } from '@/config/nfts';
import { useAptosStore } from '@/stores/aptos';
import { formatAddress } from '@/utils/format';

const aptosStore = useAptosStore();
const { account } = storeToRefs(aptosStore);

const emit = defineEmits(['summon']);

const props = withDefaults(
  defineProps<{
    detail: any;
    imgSize?: string | number;
  }>(),
  {
    detail: null,
    imgSize: 275,
  },
);

watch(
  () => props.detail,
  (val) => {
    console.log('watch props.detail ==>', val);
  },
);

const weaponNo = computed(() => {
  if (!props.detail?.token_name) return '';
  const splitList = props.detail?.token_name?.split('#') || [];
  const no = splitList[splitList?.length - 1];
  return `#${no}`;
});

const properties = computed(() => {
  return props.detail?.token_properties;
});

function callSummon(detail: any) {
  emit('summon', detail);
}
</script>
<style lang="scss" scoped>
.weapon-box-wrapper {
  position: relative;
  display: flex;
  width: 762px;
  height: 237px;
  padding: 25px 42px;
  margin-bottom: 25px;
  border-radius: 20px;
  background-color: #fff;
  color: #000;

  .summon-btn {
    position: absolute;
    top: 27px;
    right: 32px;
    color: #000;
  }

  .weapon-img {
    margin-right: 30px;
    flex-shrink: 0;
    height: 100%;

    img {
      height: 100%;
    }
  }

  .info {
    .block {
      .label {
        margin-bottom: 5px;
        font-size: 18px;
        line-height: 24px;
        color: #979797;
      }
    }

    .block.quality {
      margin-bottom: 10px;
      .progress {
        display: flex;
        align-items: center;
      }
      .percentage {
        margin-left: 8px;
        font-size: 18px;
        line-height: 24px;
      }
    }
    .footer {
      display: flex;
    }

    .footer-item {
      .label {
        font-size: 18px;
        line-height: 24px;
        color: #979797;
      }
      .info {
        font-size: 18px;
        line-height: 24px;
        color: #3d3d3d;
      }
    }

    .footer-item + .footer-item {
      margin-left: 80px;
    }

    .name-block {
      display: flex;
      align-items: center;
      margin-bottom: 16px;
      color: #000;
      .name {
        font-size: 26px;
        margin-right: 10px;
      }
      .code {
        font-size: 16px;
        line-height: 24px;
        color: #3d3d3d;
      }
    }
  }
}
</style>
