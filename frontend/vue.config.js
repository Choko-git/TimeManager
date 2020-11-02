const webpack = require('webpack');

module.exports = {
  outputDir: '/Users/paulmanagau/epitech/api-project/mobile/www',
  publicPath: '',
  
  configureWebpack: {
    plugins: [
      new webpack.ProvidePlugin({jQuery: 'jquery'})
    ],
  },

  css: {
    loaderOptions: {
      scss: {
          additionalData : `@import "@/assets/styles/main.scss";`
      }
    }
  },

  publicPath: '',

  pluginOptions: {
    cordovaPath: 'src-cordova'
  }
};
