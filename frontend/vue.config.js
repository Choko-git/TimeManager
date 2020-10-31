const webpack = require('webpack');

module.exports = {
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
    }
  };