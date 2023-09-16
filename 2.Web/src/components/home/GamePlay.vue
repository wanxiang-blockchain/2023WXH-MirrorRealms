<template>
  <div class="swiper-page" :class="[plantform]">
    <BackGround :bg-url="getImgUrl('bgnormal.png', 'orig')" />

    <PageTitle title="Gameplay" />

    <div class="swiper-page-content">
      <div class="game-play-box">
        <n-carousel
          ref="swiperRef"
          effect="card"
          prev-slide-style="transform: translateX(-80%) translateZ(-220px);"
          next-slide-style="transform: translateX(-20%) translateZ(-220px);"
          style="height: 516px"
          :show-dots="false"
        >
          <n-carousel-item :style="{ width: '60%' }">
            <div>
              <img class="carousel-img" :src="getImgUrl('gameplay1.png')" />
              <div class="label">Switch your favorite character</div>
            </div>
          </n-carousel-item>
          <n-carousel-item :style="{ width: '60%' }">
            <div>
              <img class="carousel-img" :src="getImgUrl('gameplay2.jpg')" />
              <div class="label">Team up with your friends to compete</div>
            </div>
          </n-carousel-item>
          <n-carousel-item :style="{ width: '60%' }">
            <div>
              <img class="carousel-img" :src="getImgUrl('gameplay3.jpg')" />
              <div class="label">Use strategy to switch weapons and defeat the enemy</div>
            </div>
          </n-carousel-item>
        </n-carousel>

        <div class="switch left" @click="switchSwiper('prev')">
          <img :src="SwitchLeft" alt="" />
        </div>
        <div class="switch right">
          <img :src="SwitchRight" alt="" @click="switchSwiper('next')" />
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import { NCarousel, NCarouselItem } from 'naive-ui';
import SwitchLeft from '@/assets/img/swiper_left_arrow.png';
import SwitchRight from '@/assets/img/swiper_right_arrow.png';
import BackGround from '../common/BackGround.vue';
import PageTitle from '../common/PageTitle.vue';
import { getImgUrl, plantform } from '@/utils';

const swiperRef = ref();

function switchSwiper(type: 'prev' | 'next') {
  swiperRef.value[type]();
}
</script>

<style lang="scss" scoped>
.swiper-page.win {
  .swiper-page-content {
    padding-top: 13%;
  }
}
.swiper-page-content {
  padding-top: 17%;
}
.game-play-box {
  position: relative;
}

.img-wrapper {
  position: relative;
}
.carousel-img {
  margin: 0 auto;
  width: 900px;
  height: 516px;
  object-fit: cover;
  display: block;
}

.label {
  margin: 0 auto;
  width: 900px;
  height: 68px;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(54.4px);
  color: #fff;
  font-size: 24px;
  line-height: 66px;
  text-align: center;
  position: relative;
  top: -68px;
}

.switch {
  position: absolute;
  width: 68px;
  top: 200px;
  cursor: pointer;

  img {
    width: 100%;
  }

  &.left {
    left: 380px;
  }

  &.right {
    right: 380px;
  }
}
</style>
