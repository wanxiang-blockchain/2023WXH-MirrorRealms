export type FuncNameType = typeof _functions;
export type FuncNameKeys = keyof FuncNameType;

export const contractAddress = {
  Testnet: '0x454e8d28247cb1869532ca2cbbf19e1310a307af2a687b6de640981f476671b6',
  Mainnet: '',
};

export const _functions = {
  mint: {
    // Testnet:
    //   '0x7cb76b35287055db9dc1a743961dc1191b4261fad92a1b76f129f5ee9a7b5aa5::candymachine::mint_script',
    Testnet: `${contractAddress.Testnet}::weapon::mint`,
    Mainnet: '',
  },
  get_weapon_by_object: {
    Testnet: `${contractAddress.Testnet}::weapon::get_weapon_by_object`,
    Mainnet: '',
  },
  craft: {
    Testnet: `${contractAddress.Testnet}::weapon::craft`,
    Mainnet: '',
  },
};
