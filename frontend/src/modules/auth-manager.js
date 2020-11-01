import axios from "axios";
import router from '@/router';
import store from '@/store';

let used = false;

function checkToken() {
    return new Promise((resolve) => {
        if (!used) {
            used = true
            const token = localStorage.getItem('token')
            if (token) {
                axios.get("http://localhost:4000/api/users/log_in/token")
                    .then(result => auth(result).then(() => resolve(true)))
                    .catch(() => {
                        localStorage.removeItem('token');
                        resolve(false)
                    })
            }
            else {
                resolve(false)
            }
        }
    })

}

function auth(res) {
    localStorage.setItem('token', res.data.token)
    return store.dispatch("change", {
        isAuth: true,
        user: res.data.user,
    })
}

function authAndRedirect(res) {
    auth(res).then(() => router.push('/home'))
}

function logOutAndRedirect() {
    logOut().then(() => router.push('/log-in'))
}

function logOut() {
    localStorage.removeItem('token')
    return store.dispatch("change", {
        isAuth: false,
        user: null,
    })
}

export { checkToken, authAndRedirect, logOutAndRedirect };