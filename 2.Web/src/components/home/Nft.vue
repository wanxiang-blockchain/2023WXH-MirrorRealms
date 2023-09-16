<template>
  <div class="swiper-page" :class="[plantform]">
    <BackGround :bg-url="getImgUrl('bgnormal.png', 'orig')" />
    <PageTitle title="NFTs" />

    <div class="swiper-page-content">
      <div class="page-item">
        <img class="bg" :src="getImgUrl('nftbg.png')" alt="" />
        <img class="nft" :src="getImgUrl('nft1.png')" alt="" />
        <div class="label">Weapon</div>
      </div>
      <div class="page-item">
        <img class="bg" :src="getImgUrl('nftbg.png')" alt="" />
        <img class="nft" :src="getImgUrl('nft2.png')" alt="" />
        <div class="label">WorldView Card</div>
      </div>
      <div class="page-item">
        <img class="bg" :src="getImgUrl('nftbg.png')" alt="" />
        <img class="nft" :src="getImgUrl('nft3.png')" alt="" />
        <div class="label">Skins</div>
      </div>
      <div class="page-item">
        <img class="bg" :src="getImgUrl('nftbg.png')" alt="" />
        <img class="nft" :src="getImgUrl('nft4.png')" alt="" />
        <div class="label">Season badge</div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import BackGround from '../common/BackGround.vue';
import PageTitle from '../common/PageTitle.vue';
import { getImgUrl, getAssetsUrl, plantform } from '@/utils';
</script>

<style lang="scss" scoped>
.swiper-page.win {
  .swiper-page-content {
    padding-top: 14%;
  }
}

.swiper-page-content {
  display: flex;
  justify-content: center;
  padding-top: 18%;

  .page-item {
    position: relative;
    width: 360px;
    height: 426px;
    margin: 0 20px;
    overflow: hidden;

    .bg {
      position: absolute;
      left: -30px;
      top: -400px;
      width: 400px;
      height: 900px;
      z-index: -1;
    }

    .nft {
      width: 100%;
    }
  }

  .page-item:nth-child(2) {
    .nft {
      width: 130%;
      margin-left: -60px;
    }
  }

  .page-item:nth-child(3) {
    .nft {
      width: 130%;
      margin-top: -40px;
    }
  }
  .page-item:nth-child(4) {
    .nft {
      width: 130%;
      margin-left: -80px;
    }
  }

  .label {
    position: absolute;
    left: 0;
    bottom: 0;
    width: 100%;
    height: 68px;
    background: rgba(0, 0, 0, 0.6);
    font-size: 24px;
    text-align: center;
    line-height: 68px;
    backdrop-filter: blur(27.2px);
    color: #fff;
  }
}
</style>
