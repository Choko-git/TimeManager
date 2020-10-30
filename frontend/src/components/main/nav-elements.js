import store from '../../store'

store.watch(
    (state) => state.auth,
    (auth) => auth.isAuth ? createRoutes(auth.user.role) : deleteRoutes()
)
let navRoutes = [];

let allRoutes = {
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
        route: '/managements',
        title: 'Management',
        icon: 'cogs'
    },
    declare: {
        route: '/declare',
        title: 'Declare',
        icon: 'clock'
    }
}

function createRoutes(role) {
    const mainLinks = [allRoutes.home];
    mainLinks.push(role === 'employee' ? allRoutes.myTeams : allRoutes.manage)
    navRoutes.push({
        name: 'Main',
        links: mainLinks
    })
    if (role !== 'admin') {
        navRoutes.push({
            name: 'Clock',
            links: [allRoutes.declare]
        })
    }
}

function deleteRoutes() {
    navRoutes = [];
}

export default navRoutes
