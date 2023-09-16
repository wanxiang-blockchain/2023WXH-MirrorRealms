module.exports = {
  plugins: {
    'postcss-pxtorem': {
      rootValue: 192,
      propList: ['*'],
      // exclude: /(node_module)/,
      // selectorBlackList: ['.norem'], // 过滤掉.norem-开头的class，不进行rem转换
      minPixelValue: 1,
    },
  },
};
