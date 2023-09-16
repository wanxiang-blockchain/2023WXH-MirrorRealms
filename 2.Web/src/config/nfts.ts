export function getWeapenQualityColor(quality: number | string) {
  const q = Number(quality);
  if (q === 100) {
    return '#FE4D00';
  } else if (q >= 80 && q <= 99) {
    return '#FB52FF';
  } else if (q >= 50 && q <= 79) {
    return '#00B0F0';
  } else if (q >= 20 && q <= 49) {
    return '#92D050';
  } else if (q >= 0 && q <= 19) {
    return '#F2F2F2';
  }
}

export const props = {};
