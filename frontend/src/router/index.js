import Vue from 'vue';
import VueRouter from 'vue-router';
import store from '@/store'
import LogIn from '@/views/commons/LogIn.vue'
import { checkToken } from '@/modules/auth-manager';

/** IMPORT ROUTES */
import mainRoutes from './main';
import employeeRoutes from './employee';
import managementRoutes from './management';

let routerLoading = false;
let isAuth = false;
let usedRoutes = null;

Vue.use(VueRouter)

const routes = [
  {
    path: '/log-in',
    name: 'LogIn',
    component: LogIn
  }
]

let router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

// /** @todo Temp */
// isAuth = true;
// const role = 'manager'
// router.addRoutes(mainRoutes);
// router.addRoutes(['manager', 'admin'].includes(role) ? managementRoutes : employeeRoutes)
// router.addRoutes([{
//   path: '*',
//   redirect: '/home'
// }])
// /** ---------- */

router.beforeEach((to, from, next) => {

  if (!routerLoading) {
    console.log(to.name);
    if (!isAuth && to.name !== 'LogIn') {
      routerLoading = true;
      checkToken(next)
        .then(checked => {
          routerLoading = false;
          console.log(checked);
          next({ name: checked ? checkPath(to.path) || 'Home' : 'LogIn' });
        });
    }
    else next()
  }
})

const checkPath = (path) => usedRoutes.find(_ => _.path === path)?.name;

store.watch(
  (state) => state.auth,
  function (auth) {
    isAuth = auth.isAuth;
    if (isAuth) {
      const role = auth.user.role
      const newRoutes = generateRoutes(role)
      router.addRoutes([...mainRoutes, ...newRoutes]);
      usedRoutes = newRoutes.filter(_ => _.path !== '/management');
    }
    else {
      usedRoutes = null;
      router = new VueRouter({
        mode: 'history',
        base: process.env.BASE_URL,
        routes
      })
    }
  }
)

function generateRoutes(role) {
  const newRoutes = [];
  if (role === 'employee') {
    newRoutes.push(...employeeRoutes);
  }
  else {
    newRoutes.push(...managementRoutes)
    if (role === 'manager') {
      newRoutes.push(employeeRoutes[0]);
    }
  }
  return newRoutes;
}

export default router