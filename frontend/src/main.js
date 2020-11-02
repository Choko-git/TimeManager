import Vue from 'vue'
import './plugins/bootstrap-vue'
import './modules/data-getter.js'
import App from './App.vue'
import store from "./store";
import router from './router'
import requestInterceptor from './interceptor';
requestInterceptor();

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
