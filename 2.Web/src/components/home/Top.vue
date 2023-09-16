<template>
  <div class="swiper-page">
    <BackGround :bg-url="getImgUrl('firstpage', 'orig')" />

    <div class="swiper-page-content">
      <div class="preview" @click="handleShowVideo">
        <img :src="getImgUrl('videocover.png')" alt="" />
        <img class="round" :src="getAssetsUrl('play_round.png')" alt="" />
        <img class="arrow" :src="getAssetsUrl('play_arrow.png')" alt="" />
      </div>
      <div
        class="video-cover animate__animated animate__faster"
        :class="{ 'visible animate__fadeIn': state.showVideo }"
        @click="handleHideVideo"
      ></div>

      <!-- <div class="play-btn" @click.stop="handleShowVideo">
        <img :src="getImgUrl('play.png')" alt="" />
      </div> -->

      <div
        class="video-wrapper animate__animated animate__faster"
        :class="{ 'visible animate__fadeIn': state.showVideo }"
      >
        <div id="yt-video"></div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { reactive, onMounted, watch } from 'vue';
import YouTubePlayer from 'youtube-player';
import BackGround from '../common/BackGround.vue';

import config from '@/config';
import { getImgUrl, getAssetsUrl } from '@/utils';

const props = defineProps({
  activeIndex: Number,
});

const state: { showVideo: boolean } = reactive({
  showVideo: false,
});

let player: any = null;

const handleShowVideo = () => {
  state.showVideo = true;
  if (player) {
    player.playVideo();
  }
};

const handleHideVideo = () => {
  state.showVideo = false;
  player.stopVideo();
};

watch(
  () => props.activeIndex,
  (newIndex) => {
    if (newIndex !== 0) {
      player.pauseVideo();
    }
  },
);

onMounted(() => {
  player = YouTubePlayer('yt-video', {
    videoId: config.top.videoId,
    width: '100%',
    height: '100%',
  });
  player.mute();
});
</script>

<style lang="scss" scoped>
.preview {
  position: absolute;
  left: 150px;
  bottom: 100px;
  width: 375px;
  cursor: pointer;

  img {
    width: 100%;
  }

  .round {
    position: absolute;
    left: 50px;
    bottom: 50px;
    width: 70px;
  }

  .arrow {
    position: absolute;
    left: 76px;
    bottom: 73px;
    width: 23px;
  }
}
.video-wrapper {
  position: fixed;
  left: 420px;
  top: 50%;
  width: 1080px;
  height: 720px;
  z-index: 999;
  display: none;
  transform: translate3d(0, -45%, 0);
}

.video-wrapper.visible {
  display: block;
}

.play-btn {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 80px;
  height: 80px;
  font-size: 40px;
  transform: translate3d(-50%, -50%, 0);
  cursor: pointer;

  img {
    width: 100%;
    height: 100%;
    display: block;
  }

  img:hover {
    width: 100%;
    height: 100%;
    display: block;
    animation: pulse;
    animation-duration: 0.6s;
    animation-iteration-count: infinite;
  }
}

.video-cover {
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.6);
  display: none;
}
.video-cover.visible {
  display: block;
}
</style>
