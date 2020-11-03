import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    auth: {
      isAuth: false,
      user: null,
    },
    data: null
  },
  mutations: {
    changeAuth: (state, auth) => state.auth = auth,
    changeData: (state, data) => state.data = data,
  },
  actions: {
    changeAuth: ({ commit }, auth) => commit('changeAuth', auth),
    changeData: ({ commit }, data) => commit('changeData', data)
  },
  getters: {
    auth: state => state.auth
  }
});
