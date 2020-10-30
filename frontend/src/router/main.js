import Home from '../views/commons/Home.vue';
import Declare from '../views/commons/Declare.vue';

const routes = [
    {
        path: '/',
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