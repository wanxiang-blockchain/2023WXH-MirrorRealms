const regExp = {
  email: /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/,
  password: /^[A-Za-z0-9]+$/,
};

/**
 * 校验邮箱
 * @param str
 * @returns
 */
export function checkEmail(str: string) {
  return regExp.email.test(str);
}

/**
 * 校验密码
 * @param str
 * @returns
 */
export function checkPassword(str: string) {
  return regExp.password.test(str);
}
