export type NetworkType = 'Mainnet' | 'Testnet';
export type xxx = '';

export interface NewNetWorkType {
  chainId: string;
  name: NetworkType;
  url: string;
}

export interface AccountType {
  address: string;
  publicKey: string;
}

export interface SignType {
  address: string;
  fullMessage: string;
  signature: string;
}

export interface AptosErrorType {
  code: 4000 | 4001 | 4100;
  name: string;
  message?: string;
}
