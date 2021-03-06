import store from '../../store'

store.watch(
    (state) => state.auth,
    (auth) => auth.isAuth ? createMainRoutes(auth.user.role) : deleteRoutes()
)
let navRoutes = [];
let managementNavRoutes = [];

const allMainRoutes = {
    home: {
        route: '/home',
        title: 'Home',
        icon: 'home'
    },
    myTeams: {
        route: 'my-teams',
        title: 'My Teams',
        icon: 'users'
    },
    manage: {
        route: '/management',
        title: 'Management',
        icon: 'cogs'
    },
    declare: {
        route: '/declare',
        title: 'Declare',
        icon: 'clock'
    },
}
const allManagementRoutes = [
    {
        route: '/management/dashboard',
        title: 'Dashboard'
    }, {
        route: '/management/employees',
        title: 'Employees'
    }, {
        route: '/management/teams',
        title: 'Teams'
    }]

function createMainRoutes(role) {
    const mainLinks = [allMainRoutes.home];
    const isEmployee = role === 'employee';
    mainLinks.push(isEmployee ? allMainRoutes.myTeams : allMainRoutes.manage)
    navRoutes.push({
        name: 'Main',
        links: mainLinks
    })
    if (role !== 'admin') {
        navRoutes.push({
            name: 'Clock',
            links: [allMainRoutes.declare]
        })
    }
    if (!isEmployee) {
        allManagementRoutes.map(_ => managementNavRoutes.push(_));
    }
}


function deleteRoutes() {
    navRoutes = [];
    managementNavRoutes = [];
}

export {
    managementNavRoutes,
    navRoutes
}

// /** @todo Temp */
// createMainRoutes('manager')
// /** ---------- */