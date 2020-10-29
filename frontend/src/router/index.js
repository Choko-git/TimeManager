import Vue from 'vue'
import VueRouter from 'vue-router'
import LogIn from '../views/LogIn.vue'
import store from '../store'
let isAuth = false;

Vue.use(VueRouter)

const routes = [
  {
    path: '/log-in',
    name: 'LogIn',
    component: LogIn
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  if (to.name !== 'LogIn' && !isAuth) next({ name: 'LogIn' })
  else next()
})  

store.watch(
  (state) => state.auth,
  function (auth) {
    isAuth = auth.isAuth;
    
  }
)

export default router
