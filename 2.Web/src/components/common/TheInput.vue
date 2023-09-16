<template>
  <div class="the-input-wrapper" :class="[noMargin ? 'no-margin' : '']">
    <div class="label">{{ label }}</div>
    <n-input
      class="custom-input"
      :class="[className]"
      v-model:value="value"
      :type="type"
      :size="size"
      :placeholder="placeholder"
      @update:value="onChange"
    />
  </div>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue';
import { NInput } from 'naive-ui';
const emit = defineEmits(['update:modelValue']);
const props = withDefaults(
  defineProps<{
    modelValue: string;
    label?: string;
    type?: 'text' | 'textarea' | 'password';
    size?: 'tiny' | 'small' | 'medium' | 'large';
    className?: string;
    placeholder?: string;
    noMargin?: boolean;
  }>(),
  {
    modelValue: '',
    label: '',
    type: 'text',
    size: 'medium',
    className: '',
    placeholder: '',
  },
);

const value = ref(props.modelValue);

watch(
  () => props.modelValue,
  (val) => {
    value.value = val || '';
  },
);

const onChange = (val: string) => {
  console.log(val);
  emit('update:modelValue', val);
};
</script>

<style scoped lang="scss">
.the-input-wrapper {
  width: 100%;
  padding: 7px 10px 7px 10px;
  margin-bottom: 19px;
  border-radius: 8px;
  background-color: #f2f2f2;

  &.no-margin {
    margin-bottom: 0;
  }
}

.label {
  font-size: 9px;
  font-weight: 250;
  line-height: 11px;
  color: #6e6e6e;
  margin-bottom: 4px;
}

:deep(.custom-input) {
  --n-border: 0 !important;
  --n-border-hover: 0 !important;
  --n-border-focus: 0 !important;
  --n-border-focus-warning: 0 !important;
  --n-caret-color: #313131 !important;
  --n-loading-color: #f2f2f2 !important;
  --n-caret-color-warning: #f2f2f2 !important;
  --n-border-warning: 0 !important;
  --n-border-hover-warning: 0 !important;
  --n-box-shadow-focus: none !important;
  background-color: #f2f2f2 !important;
}
</style>
