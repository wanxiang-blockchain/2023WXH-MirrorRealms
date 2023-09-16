<template>
  <div class="the-modal-rapper" :class="{ visible }">
    <div
      class="mask animate__animated animate__faster"
      :class="{ 'visible animate__fadeIn': visible }"
      @click="onClose"
    ></div>

    <div
      class="the-modal-content animate__animated animate__faster"
      :class="{ 'visible animate__fadeIn': visible }"
      :style="{ width: computedWidth, padding }"
    >
      <div class="title" v-if="props.title"></div>
      <slot></slot>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { computed } from 'vue';

const emit = defineEmits(['close']);

const props = defineProps({
  visible: {
    type: Boolean,
    default: false,
  },
  title: {
    type: String,
    default: null,
  },
  width: {
    type: [Number, String],
    default: 600,
  },
  padding: {
    type: [String],
    default: '30px',
  },
});

/**
 * 模态框宽度
 * 支持传入数字（px）和其他自定义单位
 */
const computedWidth = computed(() => {
  if (typeof props.width === 'number') {
    return `${props.width}px`;
  }
  return props.width;
});

const onClose = () => {
  emit('close');
};
</script>

<style scoped lang="scss">
.the-modal-rapper {
  position: fixed;
  display: none;
  width: 100%;
  height: 100%;
  z-index: 101;

  &.visible {
    display: block;
  }
}

.the-modal-content {
  position: fixed;
  left: 50%;
  top: 50%;
  display: none;
  transform: translate3d(-50%, -50%, 0);
  width: 600px;
  min-height: 300px;
  padding: 30px;
  border-radius: 32px;
  background-color: #fff;

  &.visible {
    display: block;
  }
}

.mask {
  position: fixed;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.6);
  display: none;

  &.visible {
    display: block;
  }
}
</style>
