<template>
  <div class="weapon-box-wrapper">
    <div class="weapon-img" :style="{ width: computedImgSize, height: computedImgSize }">
      <img :src="detail?.uri" alt="" />
    </div>
    <div class="info text-thin">
      <div class="name-block">
        <div class="name">{{ detail?.weapon?.name }}</div>
        <div class="code">{{ weaponNo }}</div>
      </div>

      <div class="block quality">
        <div class="label">Quality</div>
        <div class="progress">
          <n-progress
            type="line"
            :percentage="Number(detail?.weapon?.quality) || 0"
            :height="18"
            :border-radius="4"
            :fill-border-radius="0"
            rail-color="#fff"
            rail-style="border:1px solid #ccc"
            :color="getWeapenQualityColor(Number(detail?.weapon?.quality) || 0)"
            :show-indicator="false"
          />
          <span class="percentage">{{ weapon?.quality }}</span>
        </div>
      </div>

      <div class="block skills">
        <div class="label">props</div>
        <div class="skill" v-for="(skill, index) in weapon?.skills" :key="index">
          {{ skill.name }} + {{ np.divide(skill.rating || 0, 100) }}%
        </div>
      </div>
    </div>
  </div>
</template>
<script lang="ts" setup>
import { computed, watch } from 'vue';
import { NProgress } from 'naive-ui';
import np from 'number-precision';
import { getWeapenQualityColor } from '@/config/nfts';

interface IWeaponDetail {
  name: string;
  uri: string;
  weapon: WeaponType;
}
interface WeaponType {
  color: string;
  name: string;
  quality: string;
  skills?: { name: string; rating: string; typeIndex: string }[];
}

const defaultWeapon = {
  color: '',
  name: '',
  quality: '',
  skills: [],
};

const props = withDefaults(
  defineProps<{
    detail: IWeaponDetail | null;
    imgSize?: string | number;
  }>(),
  {
    detail: null,
    imgSize: 275,
  },
);

watch(
  () => props.detail,
  (val) => {
    console.log('watch props.detail ==>', val);
  },
);

const computedImgSize = computed(() => {
  console.log('imgSize', props.imgSize);
  if (typeof props.imgSize === 'string') {
    return props.imgSize;
  }
  return `${props.imgSize}px`;
});

const weapon = computed(() => {
  return props.detail?.weapon || defaultWeapon;
});

const weaponNo = computed(() => {
  if (!props.detail?.name) return '';
  const splitList = props.detail?.name?.split('#') || [];
  const no = splitList[splitList?.length - 1];
  return `#${no}`;
});
</script>
<style lang="scss" scoped>
.weapon-box-wrapper {
  display: flex;
  justify-content: center;
  width: 100%;
  background-color: #fff;

  .custom-rail-style {
    border: 1px solid #ddd;
  }

  .weapon-img {
    margin-right: 73px;
    flex-shrink: 0;

    img {
      width: 100%;
    }
  }

  .info {
    width: 200px;
    .block {
      .label {
        margin-bottom: 5px;
        font-size: 18px;
        line-height: 24px;
        color: #979797;
      }
    }

    .block.quality {
      margin-bottom: 26px;
      .progress {
        display: flex;
        align-items: center;
      }
      .percentage {
        margin-left: 8px;
        font-size: 18px;
        line-height: 24px;
      }
    }

    .block.skills {
      .skill {
        font-size: 18px;
        line-height: 24px;
        color: #3d3d3d;
      }
    }

    .name-block {
      margin-bottom: 26px;
      .name {
        font-size: 36px;
        margin-bottom: 10px;
      }
      .code {
        font-size: 18px;
        line-height: 24px;
        color: #3d3d3d;
      }
    }
  }
}
</style>
