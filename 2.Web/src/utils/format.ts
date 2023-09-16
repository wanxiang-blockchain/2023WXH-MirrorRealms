import np from 'number-precision';

export function formatAddress(address: string) {
  if (!address) return '';
  return `${address.substring(0, 4)}**${address.substring(address.length - 4, address.length)}`;
}

/**
 * 格式化apt
 */
export function formatApt(coin: number | string) {
  return np.divide(coin || 0, 100000000);
}
