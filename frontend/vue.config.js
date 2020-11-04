module.exports = {
  outputDir: '../timemanager_mobile/www',
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
    cordovaPath: '../timemanager_mobile'
  }
};
