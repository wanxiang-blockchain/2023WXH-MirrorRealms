<template>
  <div class="page-title-wrapper" :style="{ top: cTop }">
    <div class="arrow left">
      <img :src="getAssetsUrl('left_arrow.png')" alt="" />
    </div>
    <div class="title">{{ title }}</div>
    <div class="arrow right">
      <img :src="getAssetsUrl('right_arrow.png')" alt="" />
    </div>
  </div>
</template>

<script lang="ts" setup>
import { computed } from 'vue';
import { getAssetsUrl, plantform } from '@/utils';

const props = defineProps({
  title: {
    type: String,
    default: '',
  },
  top: {
    type: String,
    default: '10%',
  },
});

const cTop = computed(() => {
  if (props.top) return props.top;
  return plantform === 'mac' ? '12%' : '9%';
});
</script>

<style lang="scss" scoped>
.page-title-wrapper {
  position: absolute;
  display: flex;
  justify-content: center;
  width: 100%;
  align-items: center;
  margin: 0 auto;
}

.arrow {
  display: flex;
  align-items: center;

  img {
    width: 260px;
  }
}

.title {
  font-size: 72px;
  font-weight: 250;
  line-height: 86px;
  opacity: 0.9;
  color: #fff;
}
</style>
