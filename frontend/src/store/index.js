import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    auth: {
      isAuth: false,
      user: null
    }
  },
  mutations: {
    change(state, auth) {
      state.auth = auth;
    }
  },
  actions: {
    change({ commit }, auth) {
      commit('change', auth)
    }
  },
  getters: {
    auth: state => state.auth
  }
});
