<template>
  <div class="weapon-box-wrapper" :class="{ active }" @click="onSelect(detail)">
    <div class="weapon-img" :style="{ width: computedImgSize, height: computedImgSize }">
      <img :src="detail?.token_uri" alt="" />
    </div>
    <div class="info text-thin">
      <div class="name-block">
        <div class="name">{{ properties?.weapon_type }}</div>
        <div class="code">{{ weaponNo }}</div>
      </div>

      <div class="block quality">
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
          <div class="info">{{ properties?.prop1 }}</div>
          <div class="info">{{ properties?.prop2 }}</div>
        </div>
      </div>
    </div>

    <div class="selected-icon" v-if="active">
      <img :src="getAssetsUrl('check.png')" alt="" />
    </div>
  </div>
</template>
<script lang="ts" setup>
import { computed, watch } from 'vue';
import { NProgress } from 'naive-ui';
import { getWeapenQualityColor } from '@/config/nfts';
import { getAssetsUrl } from '@/utils';

const emit = defineEmits(['select']);

const props = withDefaults(
  defineProps<{
    detail: any;
    imgSize?: string | number;
    active?: boolean;
    canSelected?: boolean;
  }>(),
  {
    detail: null,
    imgSize: 75,
    active: false,
    canSelected: true,
  },
);

watch(
  () => props.detail,
  (val) => {
    console.log('watch props.detail ==>', val);
  },
);

const computedImgSize = computed(() => {
  if (typeof props.imgSize === 'string') {
    return props.imgSize;
  }
  return `${props.imgSize}px`;
});

const weaponNo = computed(() => {
  if (!props.detail?.token_name) return '';
  const splitList = props.detail?.token_name?.split('#') || [];
  const no = splitList[splitList?.length - 1];
  return `#${no}`;
});

const properties = computed(() => {
  return props.detail?.token_properties;
});

function onSelect(detail: any) {
  if (!props.canSelected) return;
  emit('select', detail);
}
</script>
<style lang="scss" scoped>
.weapon-box-wrapper {
  position: relative;
  display: flex;
  width: 100%;
  padding: 18px;
  margin-bottom: 15px;
  border-radius: 20px;
  background-color: #fff;
  color: #000;
  border: 1px solid #d8d8d8;
  cursor: pointer;

  &.active {
    border: 1px solid #1ceaee;
  }

  .selected-icon {
    position: absolute;
    top: 18px;
    right: 18px;
    width: 20px;
    height: 20px;

    img {
      width: 100%;
    }
  }

  .summon-btn {
    position: absolute;
    top: 27px;
    right: 32px;
    color: #000;
  }

  .weapon-img {
    margin-right: 10px;
    flex-shrink: 0;

    img {
      width: 100%;
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
      margin-bottom: 4px;
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
      display: flex;
      .info {
        font-size: 12px;
        line-height: 24px;
        color: #3d3d3d;
      }

      .info + .info {
        margin-left: 16px;
      }
    }

    .name-block {
      display: flex;
      align-items: center;
      color: #000;
      margin-bottom: 6px;
      .name {
        max-width: 160px;
        font-size: 18px;
        margin-right: 10px;
        word-break: break-all;
      }
      .code {
        font-size: 12px;
        line-height: 24px;
        color: #3d3d3d;
      }
    }
  }
}
</style>
