import Dashboard from '../views/management/Dashboard.vue';
import Employee from '../views/management/Employee.vue';
import Employees from '../views/management/Employees.vue';
import Team from '../views/management/Team.vue';
import Teams from '../views/management/Teams.vue';

const routes = [
    {
        path: '/management',
        redirect: '/management/dashboard',
    },
    {
        path: '/management/dashboard',
        name: 'Dashboard',
        component: Dashboard
    },
    {
        path: '/management/employee',
        name: 'Employee',
        component: Employee
    },
    {
        path: '/management/employees',
        name: 'Employees',
        component: Employees
    },
    {
        path: '/management/team',
        name: 'Team',
        component: Team
    },
    {
        path: '/management/teams',
        name: 'Teams',
        component: Teams
    },
]

export default routes