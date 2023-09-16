<template>
  <div class="bg-wrapper" :style="{ background: props.bgColor }">
    <div class="bg-img" v-if="props.bgUrl">
      <img :src="props.bgUrl" alt="" />
    </div>

    <!-- <div class="bg-cover" v-if="props.bgUrl">
      <img :src="getImgUrl('cover_bg.png')" alt="" />
    </div> -->
  </div>
</template>

<script lang="ts" setup>
const props = defineProps({
  bgUrl: String,
  bgColor: {
    type: String,
    default: 'transparent',
  },
});
</script>

<style lang="scss">
.bg-wrapper {
  width: 100%;
  height: 100%;
  position: absolute;
  top: 0;
  left: 0;
}

.bg-img {
  width: 100%;
  height: 100%;
  position: absolute;
  top: 0;
  left: 0;
  z-index: -1;

  img {
    width: 100%;
  }
}

.bg-cover {
  width: 100%;
  height: 100%;
  position: absolute;
  top: 0;
  left: 0;
  background-color: rgba(0, 0, 0, 0.6);
  z-index: -1;

  img {
    width: 100%;
    height: 100%;
    opacity: 0.1;
  }
}
</style>
