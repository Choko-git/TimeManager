const webpack = require('webpack');

module.exports = {
    configureWebpack: {
      plugins: [
        //'/plugins/vue-morris'
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