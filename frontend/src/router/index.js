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
    if (!isAuth && to.name !== 'LogIn') {
      routerLoading = true;
      checkToken(next)
        .then(checked => {
          console.log(checked);
          routerLoading = false;
          if (!checked) {
            next({ name: 'LogIn' })
          }
          else {
            checkPath(to.path) ? next() : next({ name: 'Home' })
          }
        });
    }
    else next()
  }
})

const checkPath = (path) => usedRoutes.includes(path)

store.watch(
  (state) => state.auth,
  function (auth) {
    isAuth = auth.isAuth;
    if (isAuth) {
      const role = auth.user.role
      const newRoutes = generateRoutes(role)
      router.addRoutes([...mainRoutes, ...newRoutes]);
      usedRoutes = newRoutes.map(_ => _.path).filter(_ => _ !== '/management');
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