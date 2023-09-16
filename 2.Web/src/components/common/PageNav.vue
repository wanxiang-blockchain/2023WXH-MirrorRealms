<template>
  <div class="page-nav">
    <div v-for="(item, i) in state.navList" :key="i">
      <div class="nav-item" :class="{ active: i === props.activeIndex }">
        <div class="squire"></div>
        <div class="name" @click="() => onNavChange(i)">{{ item }}</div>
        <div class="line" v-if="i !== state.navList.length - 1"></div>
      </div>
    </div>
  </div>
</template>
<script lang="ts" setup>
import { reactive } from 'vue';

const props = defineProps({
  activeIndex: {
    type: Number,
    default: 0,
  },
});

const emits = defineEmits(['navChange']);

const state = reactive({
  navList: ['Top', 'Game', 'Characters', 'NFT', 'Team', 'Partners'],
});

const onNavChange = (index: number) => {
  emits('navChange', index);
};
</script>

<style lang="scss" scoped>
.page-nav {
  position: fixed;
  top: 50%;
  right: 40px;
  transform: translate3d(0, -50%, 0);
  z-index: 100;
}

.nav-item {
  position: relative;
}

.squire {
  width: 8px;
  height: 8px;
  background-color: #b2b2b2;
  border: 1px solid #fff;
  transform: rotateZ(45deg);
  transition: all 0.5s;
}

.name {
  position: absolute;
  left: -120px;
  top: -6px;
  width: 100px;
  color: #b2b2b2;
  font-size: 20px;
  text-align: right;
  transition: all 0.5s;
  cursor: pointer;
}

.line {
  width: 2px;
  height: 68px;
  background-color: #fff;
  position: relative;
  left: 3px;
}

.nav-item.active {
  .squire {
    background-color: $color-primary;
  }
  .name {
    color: #fff;
  }
}
</style>
