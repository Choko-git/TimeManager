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
    change(state, user) {
      state.user = user;
    }
  },
  actions: {
    change({ commit }, user) {
      commit('change', user)
    }
  },
  getters: {
    userId: state => state.userId
  }
});
