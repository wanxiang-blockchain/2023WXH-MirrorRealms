<template>
  <div class="swiper-page" :class="[plantform]">
    <BackGround :bg-url="getImgUrl('bgnormal.png', 'orig')" />
    <PageTitle title="Team" />

    <div class="swiper-page-content">
      <div class="team-bar">
        <div class="bar-item" v-for="(item, i) in teamList" :key="i">
          <div class="head-img">
            <img :src="item.head" alt="" />
          </div>
          <div class="name">{{ item.name }}</div>
          <div class="position">{{ item.title }}</div>
          <div class="exp">
            {{ item.exp }}
          </div>
        </div>
      </div>

      <div class="team-bar">
        <div class="bar-item" v-for="(item, i) in teamReverseList" :key="i">
          <div class="head-img">
            <img :src="item.head" alt="" />
          </div>
          <div class="name">{{ item.name }}</div>
          <div class="position">{{ item.title }}</div>
          <div class="exp">
            {{ item.exp }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import BackGround from '../common/BackGround.vue';
import PageTitle from '../common/PageTitle.vue';
import { getAssetsUrl, getImgUrl, plantform } from '@/utils';

const teamList = [
  {
    head: getImgUrl('a1.png'),
    name: 'Will Zhang',
    title: 'Founder&CEO',
    exp: '10+ years of experience in team management and continuous entrepreneurship, proficient in product design and years of experience in crypto and NFT transactions',
  },
  {
    head: getImgUrl('a2.jpg'),
    name: 'Brian Bi',
    title: 'Chief Game Designer',
    exp: "10+ years of experience in game development and planning management, leading the development of  'Tap Fantasy'.",
  },
  {
    head: getImgUrl('a3.png'),
    name: 'Broken',
    title: 'Chief Art Director',
    exp: '8+ years of experience in game art research and development, worked at miHoYo and proficient in various artistic styles and creativity, proficient in Unity3D',
  },
  {
    head: getImgUrl('a4.png'),
    name: 'Usagi Chan',
    title: 'CTO',
    exp: '10+ years of experience in game development and management, proficient in Unity development, proficient in ACT, RPG, SLG and other game development and landing.',
  },
];

const teamReverseList = [
  {
    head: getImgUrl('a5.png'),
    name: 'Neon',
    title: '2D Art Director',
    exp: '8+ years of experience in game art research and development, proficient in anime art creation.',
  },
  {
    head: getAssetsUrl('a6.jpg'),
    name: 'Zachary',
    title: 'Community Operations&PM',
    exp: '9+ years of internet work experience, MBA graduate, and extensive project management experience.',
  },
  {
    head: getAssetsUrl('a7.jpg'),
    name: 'Zoey',
    title: 'Community Operation',
    exp: '2+ years of experience in operating Web3 gaming communities, proficient in community operations such as Twitter and Discord, and worked in exchanges, packages, and gamefi  projects.',
  },
  {},
];
</script>

<style lang="scss" scoped>
.swiper-page.win {
  .swiper-page-content {
    padding-top: 11%;
  }
}

.swiper-page-content {
  padding: 0 100px;
  padding-top: 15%;
}

.team-bar {
  display: flex;
  margin-bottom: 60px;
  position: relative;
}

.bar-item {
  width: 25%;
  padding: 0 30px;
  text-align: center;
  animation-delay: 0.4s;
  color: #fff;

  .head-img {
    width: 86px;
    height: 86px;
    margin: 0 auto;
    border-radius: 50%;
    overflow: hidden;
    margin-bottom: 13px;

    img {
      display: block;
      width: 100%;
    }
  }

  .name {
    width: 100%;
    font-size: 30px;
    line-height: 36px;
    margin-bottom: 14px;
  }

  .position {
    font-size: 20px;
    line-height: 24px;
    margin-bottom: 16px;
    opacity: 0.4;
  }

  .exp {
    font-size: 20px;
    line-height: 24px;
    text-align: left;
    opacity: 0.7;
    // word-break: break-all;
  }
}
</style>
