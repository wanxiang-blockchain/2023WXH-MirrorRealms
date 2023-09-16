export enum NFT {
  NFTType_None = 0,
  NFTType_Weapon = 1,
}

export type NFTType = NFT;

export interface CReqGetAptosNFTs {
  nft_types: NFTType[];
}

export interface CResGetAptosNFTsV2 {
  nfts: AptosNFTNodeV2[];
}

export interface AptosNFTNodeV2 {
  collection_id: string;
  token_data_id: string;
  description: string;
  token_name: string;
  token_properties: Properties;
  token_standard: string;
  token_uri: string;
}

export interface Properties {
  prop1: string;
  prop2: string;
  quality: string;
  weapon_id: string;
  weapon_type: string;
}
