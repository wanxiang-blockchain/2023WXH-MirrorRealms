import axios, { AxiosInstance, AxiosError, AxiosRequestConfig, AxiosResponse } from 'axios';
import { RequestEnums, ErrorCodeMsg, ErrorCodeMsgType, ErrorCodeMsgKeys } from './codeConfig';
import { message } from '@/utils';
import { useAptosStore } from '@/stores/aptos';
import { useLocalCache } from '@/utils/storage';

const { getCache } = useLocalCache();

// 数据返回的接口
// 定义请求响应参数，不含data
interface Result {
  code: number;
  msg: string;
}

// 请求响应参数，包含data
type ResultData<T = any> = T;
const URL: string = process.env.NODE_ENV == 'production' ? 'https://mirror-realms.io:3000' : '';
// const URL: string = 'https://mirror-realms.io:3000';

const config = {
  // 默认地址
  baseURL: URL as string,
  // 设置超时时间
  timeout: RequestEnums.TIMEOUT as number,
  // 跨域时候允许携带凭证
  withCredentials: true,
};

class RequestHttp {
  // 定义成员变量并指定类型
  service: AxiosInstance;
  public constructor(config: AxiosRequestConfig) {
    // 实例化axios
    this.service = axios.create(config);
    /**
     * 请求拦截器
     * 客户端发送请求 -> [请求拦截器] -> 服务器
     * token校验(JWT) : 接受服务器返回的token,存储到vuex/pinia/本地储存当中
     */

    this.service.interceptors.request.use(
      (config: any) => {
        const Authorization = getCache('Authorization') || '';
        return {
          ...config,
          headers: {
            Authorization, // 请求头中携带token信息
          },
        };
      },
      (error: AxiosError) => {
        // 请求报错
        Promise.reject(error);
      },
    );
    /**
     * 响应拦截器
     * 服务器换返回信息 -> [拦截统一处理] -> 客户端JS获取到信息
     */

    this.service.interceptors.response.use(
      (response: AxiosResponse) => {
        const { status, data, config } = response; // 解构
        console.log(response);
        if (status === RequestEnums.OVERDUE) {
          // 登录信息失效，应跳转到登录页面，并清空本地的token
          const aptosStore = useAptosStore();
          aptosStore.clearToken();
          // router.replace({ //   path: '/login' // })
          return Promise.reject(data);
        } // 全局错误信息拦截（防止下载文件得时候返回数据流，没有code，直接报错）
        if (status !== RequestEnums.SUCCESS) {
          // message.error(data); // 此处也可以使用组件提示报错信息
          return Promise.reject(data);
        }
        return data;
      },
      (error: AxiosError) => {
        const { response } = error;
        console.log(error);
        if (response) {
          const errCode = (response.data as string).replace(/[\r\n]/g, '');
          this.handleCode(response.status, errCode as ErrorCodeMsgKeys);
        }
        if (!window.navigator.onLine) {
          // message.error('网络连接失败'); // 可以跳转到错误页面，也可以不做操作 // return router.replace({ //   path: '/404' // });
        }
        return Promise.reject(error);
      },
    );
  }

  handleCode(code: number, data: ErrorCodeMsgKeys): void {
    switch (code) {
      case 401:
        // message.error('登录失败，请重新登录');
        break;
      case 400:
        message.error(ErrorCodeMsg[data] || 'Server error, please try again later');
        break;
      case 500:
        message.error('Server error, please try again later');
        break;
      default:
        message.error('Server error, please try again later');
        break;
    }
  }

  // 常用方法封装
  get<T>(url: string, params?: object): Promise<ResultData<T>> {
    return this.service.get(url, { params });
  }
  post<T>(url: string, params?: object): Promise<ResultData<T>> {
    return this.service.post(url, params);
  }
  put<T>(url: string, params?: object): Promise<ResultData<T>> {
    return this.service.put(url, params);
  }
  delete<T>(url: string, params?: object): Promise<ResultData<T>> {
    return this.service.delete(url, { params });
  }
}

// 导出一个实例对象
export default new RequestHttp(config);
