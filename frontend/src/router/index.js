import Vue from 'vue';
import VueRouter from 'vue-router';
import store from '../store'
import LogIn from '../views/commons/LogIn.vue'

/** IMPORT ROUTES */
import mainRoutes from './main';
import employeeRoutes from './employee';
import managementRoutes from './management';

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
  console.log(isAuth);
  if (to.name !== 'LogIn' && !isAuth) {
    next({ name: 'LogIn' })
  }
  else next()
})

store.watch(
  (state) => state.auth,
  function (auth) {
    isAuth = auth.isAuth;
    const role = auth.user.role
    router.addRoutes(mainRoutes);
    router.addRoutes(['manager', 'admin'].includes(role) ? managementRoutes : employeeRoutes)
    console.log(router);
  }
)


export default router
