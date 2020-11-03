import store from '@/store';
import axios from 'axios';
import { apiUrl } from '@/env-config';
let allData;

<<<<<<< HEAD
store.watch(function (state) { state.auth.isAuth ? getAndSetData() : allData = null })
async function getAndSetData() {
    const me = await getMe();
    allData = me?.data?.data;
    if (me?.data?.role !== 'employee') {
        const employees = await getEmployees();
        allData.employees = employees?.data?.data || null;
    }
    return store.dispatch("changeData", allData)
=======
store.watch((state) => state.auth.isAuth ? getAndSetData() : deleteData())
function deleteData() { allData.length = 0 }
function getAndSetData() { getData().then(res => setData(res.data.data)) }
function getData() { return axios.get(`${apiUrl}/users`) }
function setData(data) {
    return store.dispatch("changeData", data)
>>>>>>> e7a2e9aeb8161c0e6844d677be14298c5ad4353e
}

function getMe() { return axios.get(`${apiUrl}/users/get/me`) }
function getEmployees() { return axios.get(`${apiUrl}/users`) }

export default allData;

