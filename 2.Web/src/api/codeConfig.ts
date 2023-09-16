export type ErrorCodeMsgType = typeof ErrorCodeMsg;
export type ErrorCodeMsgKeys = keyof ErrorCodeMsgType;

export const ErrorCodeMsg = {
  ERR_PARAM: '参数错误',
  ERR_DB: 'DB错误，服务器处理失败',
  ERR_MSG_DECODE: '消息解码失败',
  ERR_TOKEN_VERIFY: 'token验证错误',
  ERR_ACCOUNT_EXIST: '账号已存在',
  ERR_ACCOUNT_NOT_EXIST: '账号不存在',
  ERR_PASSWORD: '密码错误',
  ERR_CONFIG: '服务器配置错误',
  ERR_EMAIL_ADDRESS: '邮箱地址错误格式',
  ERR_EMAIL_SEND_MAX: '邮件发送已达上限',
  ERR_REPEATED_REQUEST: '重复请求',
  ERR_EMAIL_BIND_CODE: '邮箱绑定验证码错误',
  ERR_EMAIL_BOUND: '邮箱已经绑定过',
  ERR_ACC_BOUND_EMAIL: '账号已绑定过邮箱',
  ERR_APTOS_PUBLIC_KEY: 'aptos公钥错误',
  ERR_APTOS_VERIFY_SIGNATURE: 'aptos验签失败',
  ERR_NEW_PASSWD_SAME_WITH_OLD_PASSWD: '新密码与旧密码相同',
  ERR_EMAIL_VERIFICATION_CODE: '邮箱验证码错误',
};

export const RequestEnums = {
  TIMEOUT: 20000,
  OVERDUE: 401, // 登录失效
  FAIL: 400, // 请求失败
  SUCCESS: 200, // 请求成功
};
