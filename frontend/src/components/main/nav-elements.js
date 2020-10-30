import store from '../../store'

store.watch(
    (state) => state.auth,
    (auth) => auth.isAuth ? createRoutes(auth.user.role) : deleteRoutes()
)
let navRoutes = [];

let allRoutes = {
    home: {
        route: 'home',
        title: 'Home',
        icone: ''
    },
    myTeams: {
        route: 'my-teams',
        title: 'My Teams',
        icone: ''
    },
    manage: {
        route: '/management',
        title: 'Management',
        icone: ''
    },
    declare: {
        route: '/declare',
        title: 'Declare',
        icone: ''
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
