<template>
  <div class="header-bar">
    <div>
      <div class="logo">
        <a :href="indexUrl" aria-label="Mirror Realms">Mirror Realms</a>
      </div>
    </div>

    <div class="tools">
      <div v-if="props.address" class="tools-item user-name">{{ userName }}</div>
      <div v-else class="tools-item" @click="() => emit('login')">login</div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { computed } from 'vue';
import { getEnv, getIndexUrl } from '@/utils';
const props = defineProps({
  address: {
    type: String,
    default: '',
  },
});

const emit = defineEmits(['login']);

const env = getEnv();
const indexUrl = getIndexUrl(env);

const userName = computed(() => {
  return `${props.address.substring(0, 6)}...${props.address.substring(
    props.address.length - 4,
    props.address.length,
  )}`;
});
</script>

<style scoped lang="scss">
.header-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 120px;
  padding: 8px 36px;
  z-index: 100;
  background-color: rgba(0, 0, 0, 0.6);
}

.logo {
  color: #fff;
  position: relative;
  font-size: 26px;
}

.tools {
  display: flex;
  justify-content: flex-end;
  font-size: 16px;
}

.tools-item {
  padding: 18px 18px;
  border-radius: 8px;
  margin-left: 20px;
  border: 1px solid #fff;
  color: #fff;
  cursor: pointer;
  font-size: 22px;
}
</style>
