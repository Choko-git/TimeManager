import MyTeams from '../views/employee/MyTeams.vue';
import Declare from '../views/commons/Declare.vue';

const routes = [
    {
        path: '/declare',
        name: 'Declare',
        component: Declare
    },
    {
        path: '/my-teams',
        name: 'MyTeams',
        component: MyTeams
    }
]


export default routes