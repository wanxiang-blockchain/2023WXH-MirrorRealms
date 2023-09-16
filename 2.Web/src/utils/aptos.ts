import { find } from 'lodash-es';
import { useAptosStore } from '@/stores/aptos';
import { FuncNameKeys, _functions } from '@/config/aptos/transaction';

/**
 * 获取交易用的transaction
 * @param network 当前网络
 * @param func 方法名称
 * @param _arguments 参数
 * @returns
 */
export function getTransaction(func: FuncNameKeys, _arguments?: string[]) {
  const aptosStore = useAptosStore();
  return {
    function: _functions[func][aptosStore.network],
    type_arguments: [],
    arguments: _arguments || [],
    type: 'entry_function_payload',
  };
}

/**
 * 根据type获取aptos-sdk返回的数据
 * @param data sdk接口返回的数据
 * @param type
 * @returns
 */
export function getDataByType(data: any, type: string) {
  const events = data?.events || [];
  const event = find(events, (o) => o.type.indexOf(type) > -1);
  return event?.data || null;
}
