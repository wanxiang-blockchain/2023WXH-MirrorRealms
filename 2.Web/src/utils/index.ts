import { createDiscreteApi } from 'naive-ui';
import config from '@/config';

export const { message } = createDiscreteApi(['message']);

export const plantform = navigator.userAgent?.indexOf('Mac OS X') > -1 ? 'mac' : 'win';
console.log('plantform', plantform);

/**
 * 从本地缓存获取token
 * @returns
 */
export function getToken() {
  try {
    return localStorage.getItem('Authorization') || '';
  } catch (error) {
    return '';
  }
}

/**
 * 获取cdn图片地址(阿里云)
 * @param name 图片名称
 * @param useCdn 是否使用cdn
 * @param imgType 图片类型
 * @returns
 */
export const getImgUrl = (name = '', sizeType = 'offical') => {
  if (!name) return '';
  const fileName = name?.split('.')[0];
  const fileType = name?.split('.')[1] || 'webp';
  const cdnUrl = config.common.cdnUrl;
  const webpParam = `x-oss-process=style/${sizeType}`;

  return `${cdnUrl}/${fileName}.${fileType}?${webpParam}`;
};

/**
 * 获取本地图片地址
 * @param name 图片名称
 * @returns
 */
export function getAssetsUrl(name = '') {
  return new URL(`../assets/img/${name}`, import.meta.url)?.href;
}

export const getEnv = () => {
  const hostConfig: any = {
    test: ['mirror-realms.io:3000'],
    // uat: ['8.219.242.163'],
    prod: ['mirror-realms.io'],
  };
  const host = location.host.toLowerCase();
  let env = 'dev';

  Object.keys(hostConfig).some((key) => {
    if (hostConfig[key].includes(host)) {
      env = key;
      return true;
    }
    return false;
  });

  return env;
};

export const getIndexUrl = (env: string) => {
  const urls: any = {
    dev: 'http://localhost:5173',
    test: 'https://mirror-realms.io:3000',
    prod: 'https://mirror-realms.io',
  };

  return urls[env];
};
