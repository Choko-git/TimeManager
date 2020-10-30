import Home from '../views/commons/Home.vue';
import Declare from '../views/commons/Declare.vue';

const routes = [
    {
        path: '/home',
        name: 'Home',
        component: Home
    },
    {
        path: '/declare',
        name: 'Declare',
        component: Declare
    }
]

export default routes