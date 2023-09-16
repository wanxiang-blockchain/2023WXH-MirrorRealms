import { useLocalStorage } from '@vueuse/core';

const defCache = {
  Authorization: '',
  AptosWalletName: '',
  AccountAddress: '',
};

type LocalCacheValueType = typeof defCache;
type Keys = keyof LocalCacheValueType;

export function useLocalCache() {
  // 获取cache
  function getCache<T extends Keys>(key: T): LocalCacheValueType[T] {
    return useLocalStorage(key, defCache[key]).value;
  }
  // 设置cache
  function setCache<T extends Keys>(key: T, value: LocalCacheValueType[T]) {
    useLocalStorage(key, defCache[key]).value = value;
  }
  // 移除cache
  function removeCache(key: Keys) {
    useLocalStorage(key, defCache[key]).value = null;
  }
  // 清除所有cache
  function clearCache() {
    localStorage.clear();
  }
  return { getCache, setCache, removeCache, clearCache };
}
