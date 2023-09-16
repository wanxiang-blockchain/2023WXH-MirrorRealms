<template>
  <div class="swiper-page" :class="[plantform]">
    <BackGround :bg-url="getImgUrl('bgnormal.png', 'orig')" />
    <PageTitle title="Partners" />

    <div class="swiper-page-content">
      <div class="page-content">
        <div class="line">
          <div class="item" v-for="(item, i) in partnersList" :key="i">
            <img :src="item.icon" alt="" />
          </div>
        </div>
        <div class="line">
          <div class="item" v-for="(item, i) in partnersList2" :key="i">
            <img :src="item.icon" alt="" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import BackGround from '../common/BackGround.vue';
import PageTitle from '../common/PageTitle.vue';

import { getImgUrl, plantform } from '@/utils';

const partnersList = ref([
  { icon: getImgUrl('crossspace.png') },
  { icon: getImgUrl('typevdao.png') },
  { icon: getImgUrl('threedao.png') },
]);

const partnersList2 = [
  { icon: getImgUrl('aptos.png') },
  { icon: getImgUrl('mirrorworld.png') },
  { icon: getImgUrl('loa.png') },
];
</script>

<style lang="scss" scoped>
.swiper-page.win {
  .swiper-page-content {
    padding-top: 12%;
  }
}

.page-content {
  display: flex;
  flex-wrap: wrap;
  padding: 400px 0 !important;
  padding-top: 15%;

  .line {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    margin-bottom: 90px;
  }

  .item {
    padding: 30px;
    margin: 0 30px;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 318px;
    height: 130px;
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(10px);

    img {
      width: 100%;
    }
  }

  .line:nth-child(1) {
    .item {
      &:nth-child(2) {
        img {
          position: relative;
          top: -20px;
        }
      }
    }
  }

  .line:nth-child(2) {
    .item {
      &:nth-child(2),
      &:nth-child(3) {
        img {
          width: 70%;
        }
      }
    }
  }
}
</style>
