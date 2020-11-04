import store from '@/store';
import axios from 'axios';
import { apiUrl } from '@/env-config';
let allData;

store.watch(function (state) { state.auth.isAuth ? getAndSetData() : allData = null })
async function getAndSetData() {
    const me = await getMe();
    allData = me?.data?.data;
    if (me?.data?.role !== 'employee') {
        const employees = await getEmployees();
        allData.employees = employees?.data?.data || null;
    }
    return store.dispatch("changeData", allData)
}

function getMe() { return axios.get(`${apiUrl}/users/get/me`) }
function getEmployees() { return axios.get(`${apiUrl}/users`) }

export default allData;

