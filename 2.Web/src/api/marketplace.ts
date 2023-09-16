import http from './request';

export const getnonce = (data: { pktAddr: string }) => {
  return http.post<string>('/mirror/getnonce', data);
};

export const validate = (data: { pktAddr: string; sign: string }) => {
  return http.post('/mirror/validate', data);
};
