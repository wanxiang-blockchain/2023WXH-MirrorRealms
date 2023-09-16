<template>
  <div class="swiper-page" :class="[plantform]">
    <BackGround :bg-url="getImgUrl('characterbg', 'orig')" />
    <PageTitle title="Character" top="6%" />

    <div class="swiper-page-content">
      <Swiper
        ref="characterSwiper"
        :pagination="pagination"
        :effect="'fade'"
        :modules="modules"
        class="sub-swiper"
        @slideChange="onSlideChange"
      >
        <SwiperSlide v-for="(item, i) in charactersList" :key="i">
          <div class="sub-swiper-slider" :class="[`slider${i + 1}`]">
            <div class="page-info">
              <div class="name text-white">{{ item.name }}</div>
              <p class="exp">{{ item.exp }}</p>

              <div class="weapon">
                <div class="weapon-title">Weapon</div>
                <div class="flex">
                  <img
                    :src="getImgUrl(weapon)"
                    alt=""
                    v-for="(weapon, wIndex) in item.weaponList"
                    :key="wIndex"
                  />
                </div>
              </div>
            </div>

            <div
              class="character-img animate__animated animate__faster"
              :class="[
                props.activeIndex === 2 && subActiveIndex === i && 'animate__slideInRight',
                props.activeIndex === 2 && subActiveIndex !== i && 'animate__slideOutRight',
                activeType,
              ]"
            >
              <img v-if="activeType === 'normal'" :src="item.img" alt="" />
              <img v-else :src="item.demonImg" alt="" />
            </div>

            <div class="head-switch">
              <div
                class="switch-item"
                :class="{ gray: activeType !== head.type }"
                v-for="head in item.headList"
                :key="head.type"
                @click="switchType(head.type)"
              >
                <img :src="head.url" alt="" />
                <div class="label">{{ head.label }}</div>
              </div>
            </div>
          </div>
        </SwiperSlide>
      </Swiper>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue';
import BackGround from '../common/BackGround.vue';
import PageTitle from '../common/PageTitle.vue';

import { Swiper, SwiperSlide } from 'swiper/vue';
import { Pagination, EffectFade } from 'swiper';
import 'swiper/css';
import 'swiper/css/pagination';
import 'swiper/css/effect-fade';

import { getImgUrl, plantform } from '@/utils';

const props = defineProps({
  activeIndex: Number,
});

const characterSwiper = ref(null);

const charactersList = [
  {
    headList: [
      {
        type: 'normal',
        label: 'Normal',
        url: getImgUrl('eos-avt.png'),
      },
      {
        type: 'demon',
        label: 'Demonize',
        url: getImgUrl('demoneos-avt.png'),
      },
    ],
    img: getImgUrl('eos2.png'),
    demonImg: getImgUrl('demon-eos2.png'),
    name: 'Eos',
    exp: 'The snow-capped girl who has shown leadership qualities at a young age has a strong desire to conquer and longs for the power to change the world. She can always show an extremely calm side in dealing with unknown things and crises, and has led the tribe to attack the Demon Tower that appeared near the tribe many times.',
    tip: 'Big Sword',
    weaponList: ['one_handed_sword.png', 'bow.png', 'big_sword.png'],
  },
  {
    head: getImgUrl('ava2.png'),
    deamenHead: getImgUrl('ava3.png'),
    img: getImgUrl('auofia.png'),
    backImg: getImgUrl('auofia-bak.png'),
    name: 'Auofia',
    exp: 'The snow-capped girl who has shown leadership qualities at a young age has a strong desire to conquer and longs for the power to change the world. She can always show an extremely calm side in dealing with unknown things and crises, and has led the tribe to attack the Demon Tower that appeared near the tribe many times.',
    tip: 'Pestle',
  },
  {
    head: getImgUrl('ava1.png'),
    deamenHead: getImgUrl('ava3.png'),
    img: getImgUrl('eos.png'),
    backImg: getImgUrl('eos-bak.png'),
    name: 'Eos',
    exp: 'A trainee priest with the ability to hear the voices of all things, with a gentle and friendly personality. Because the tribe where she lives prohibits outsiders from entering, Eos often follows her father back and forth between the tribe and outside cities to purchase supplies, and has developed a strong communication ability. Often return to the tribe with ultra-low-cost supplies.',
    tip: '',
  },
];

const subActiveIndex = ref(0);
const activeType = ref('normal');
const modules = ref([
  // Pagination,
  EffectFade,
]);
const pagination = ref({
  clickable: true,
  renderBullet: function (index: number, className: string) {
    console.log(index);
    return `
          <div class="${className}">
            <div class="head-img">
              <img src="${charactersList[index]?.head}" alt="" />
            </div>
            <div class="title">${charactersList[index]?.name}</div>
          </div>
        `;
  },
});

const onSlideChange = (res: any) => {
  const { activeIndex } = res;
  subActiveIndex.value = activeIndex;
};

function switchType(type: string) {
  activeType.value = type;
}

onMounted(() => {
  console.log('onMounted character');
  console.log(characterSwiper?.value);
});
</script>

<style lang="scss" scoped>
.swiper-page.win {
  .page-info {
    padding-top: 8%;
  }

  .head-switch {
    bottom: 3%;
  }

  .slider1 {
    .character-img.normal {
      bottom: -600px;
    }

    .character-img.demon {
      bottom: -500px;
    }
  }
}

.swiper-page-content {
  position: relative;
}

.sub-swiper {
  width: 100%;
  height: 100%;
  position: relative;
}

.sub-swiper-slider {
  // background: linear-gradient(to top right, #030017, #1f1f1f);
  width: 100%;
  height: 100%;
}

::v-deep(.swiper-pagination) {
  bottom: 120px !important;
  left: -600px !important;
}

::v-deep(.swiper-pagination-bullet) {
  width: 100px;
  background: transparent;
  border-radius: 0;
  opacity: 1;

  .head-img {
    width: 80px;
    height: 80px;
    margin: 0 auto;
    margin-bottom: 12px;
    border: 2px solid #ccc;

    img {
      width: 100%;
    }
  }

  .title {
    font-size: 14px;
  }
}

::v-deep(.swiper-pagination-bullet-active) {
  .head-img {
    border-color: $color-primary;
  }
}

.page-info {
  width: 800px;
  padding: 200px 0 0 280px;
  position: relative;

  .name {
    font-size: 48px;
    margin-bottom: 30px;
    font-weight: bold;
  }

  .exp {
    margin-bottom: 20px;
    font-size: 20px;
    line-height: 24px;
    color: #bdbcbc;
  }

  .weapon {
    color: #bdbcbc;
    margin-top: 40px;

    .weapon-title {
      margin-bottom: 20px;
    }

    img {
      width: 90px;
    }

    img + img {
      margin-left: 20px;
    }
  }
}

.character-img {
  position: absolute;
  bottom: -140px;
  right: 240px;
  height: 1050px;

  img {
    height: 100%;
  }
}

.head-switch {
  display: flex;
  position: absolute;
  left: 280px;
  bottom: 80px;
  .switch-item {
    width: 110px;
    margin-right: 40px;
    cursor: pointer;

    .label {
      color: #fff;
      text-align: center;
      font-size: 24px;
    }

    img {
      width: 100%;
      margin-bottom: 10px;
    }
    &.gray {
      filter: grayscale(100%);
    }
  }
}

.slider1 {
  .character-img.normal {
    height: 1450px;
    right: 160px;
    bottom: -500px;
  }

  .character-img.demon {
    height: 1450px;
    right: -70px;
    bottom: -400px;
  }
}
</style>
