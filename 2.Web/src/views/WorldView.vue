<template>
  <HeaderBar show-logo />
  <div class="swiper-page">
    <BackGround :bg-url="getImgUrl('bgnormal.png', 'orig')" />

    <div class="swiper-page-content">
      <div class="page-content">
        <div class="page-item" v-for="(item, index) in list" :key="index">
          <img :src="item.img" alt="" />
          <div class="item-content">
            <div class="title">{{ item.title }}</div>
            <div class="article">{{ item.article }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import HeaderBar from '../components/common/HeaderBar.vue';
import BackGround from '@/components/common/BackGround.vue';
import { getImgUrl, getAssetsUrl } from '@/utils';

const list = [
  {
    img: getAssetsUrl('world_view1.png'),
    title: '故事标题',
    article:
      '世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容',
  },
  {
    img: getAssetsUrl('world_view1.png'),
    title: '故事标题',
    article:
      '世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容',
  },
  {
    img: getAssetsUrl('world_view1.png'),
    title: '故事标题',
    article:
      '世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容',
  },
  {
    img: getAssetsUrl('world_view1.png'),
    title: '故事标题',
    article:
      '世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容世界观故事内容',
  },
];
</script>

<style lang="scss" scoped>
.page-content {
  display: flex;
  justify-content: center;
  align-items: flex-end;

  .page-item {
    position: relative;
    width: 360px;
    margin: 0 13px;

    img {
      width: 100%;
    }
  }

  .item-content {
    position: absolute;
    left: 0;
    bottom: 0;
    width: 100%;
    padding: 26px;
    background: rgba(0, 0, 0, 0.8);
    font-size: 24px;
    line-height: 29px;
    text-align: center;
    box-shadow: 0px 0px 73.44px 0px rgba(0, 0, 0, 0.3);
  }

  .title {
    margin-bottom: 13px;
    font-weight: bold;
    color: #fff;
  }

  .article {
    color: #fff;
  }
}
</style>
