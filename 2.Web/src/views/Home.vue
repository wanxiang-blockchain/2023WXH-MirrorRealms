<template>
  <div class="home-wrapper">
    <HeaderBar :show-logo="state.activeIndex === 0" v-if="state.activeIndex === 0" />

    <!-- <PageNav :active-index="state.activeIndex" @nav-change="slideTo" /> -->

    <Swiper
      :direction="'vertical'"
      :mousewheel="true"
      :modules="state.modules"
      class="main-swiper"
      :on-init="onInit"
      @swiper="setSwiperRef"
      @slideChange="onSlideChange"
    >
      <!-- 首页 -->
      <SwiperSlide>
        <TopPage :active-index="state.activeIndex" />
      </SwiperSlide>

      <!-- 游戏 -->
      <SwiperSlide>
        <GamePlay />
      </SwiperSlide>

      <!-- 人物 -->
      <SwiperSlide>
        <CharactersPage :active-index="state.activeIndex" />
      </SwiperSlide>

      <!--nft -->
      <SwiperSlide>
        <NftPage />
      </SwiperSlide>

      <!-- 团队 -->
      <SwiperSlide>
        <TeamPage :active-index="state.activeIndex" />
      </SwiperSlide>

      <!-- 合作人 -->
      <SwiperSlide>
        <PartnersPage />
      </SwiperSlide>
    </Swiper>
  </div>
</template>

<script lang="ts" setup>
import { reactive, onMounted } from 'vue';
import HeaderBar from '../components/common/HeaderBar.vue';

// import PageNav from '../components/common/PageNav.vue';
import TopPage from '../components/home/Top.vue';
import GamePlay from '../components/home/GamePlay.vue';
import CharactersPage from '../components/home/Characters.vue';
import NftPage from '../components/home/Nft.vue';
import TeamPage from '../components/home/Team.vue';
import PartnersPage from '../components/home/Partners.vue';

import { Swiper, SwiperSlide } from 'swiper/vue';
import { Mousewheel } from 'swiper';
import 'swiper/css';

/** swiper */
const state = reactive({
  modules: [Mousewheel],
  activeIndex: 0,
});

let swiper: any = null;

const setSwiperRef = (swiperInst: any) => {
  swiper = swiperInst;
};

const slideTo = (index: number) => {
  swiper.slideTo(index);
};

const onInit = () => {
  console.log('main slide onInit');
};

const onSlideChange = (res: any) => {
  const { activeIndex } = res;
  state.activeIndex = activeIndex;
};

onMounted(() => {
  console.log('onMounted');
});
</script>

<style lang="scss">
.main-swiper {
  width: 100vw;
  height: 100vh;
  background-color: #f2f2f2;
}
</style>
