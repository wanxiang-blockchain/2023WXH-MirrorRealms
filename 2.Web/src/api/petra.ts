import http from './request';

interface IWebLoginByWallet {
  wallet_addr: string;
  pub_key: string;
  aptos_full_msg: string;
  aptos_signature: string;
}

interface ISendEmailBindCode {
  email: string;
}

interface IWebBindEmail {
  email: string;
  code: string;
}

interface IChangePassword {
  old_password: string;
  new_password: string;
}

interface IAccount {
  account: string;
  user_id: number;
  nickname: string;
  icon: string;
  email: string;
}

/**
 * 获取nonce
 * @returns
 */
export const getNonce = () => {
  return http.get<{ nonce: string }>('/mrbev1/GenerateNonce');
};

/**
 * 钱包登陆
 * @param data
 * @returns
 */
export const webLoginByWallet = (data: IWebLoginByWallet) => {
  return http.post<{ account: IAccount; resources: string; token: string }>(
    '/mrbev1/WebLoginByWallet',
    data,
  );
};

/**
 * 发送邮箱验证码
 * @param data
 * @returns
 */
export const sendEmailBindCode = (data: ISendEmailBindCode) => {
  return http.post<{}>('/mrbev1/SendEmailBindCode', data);
};

/**
 * 绑定邮箱
 * @param data
 * @returns
 */
export const webBindEmail = (data: IWebBindEmail) => {
  return http.post<{ resources: string; token: string }>('/mrbev1/WebBindEmail', data);
};

/**
 * 设置密码
 * @param data
 * @returns
 */
export const changePassword = (data: IChangePassword) => {
  return http.post<{}>('/mrbev1/ChangePassword', data);
};
