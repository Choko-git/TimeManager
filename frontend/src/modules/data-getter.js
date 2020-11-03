import store from '@/store';
import axios from 'axios';
import { apiUrl } from '@/env-config';
const allData = [];

store.watch((state) => state.auth.isAuth ? getAndSetData() : deleteData())
function deleteData() { allData.length = 0 }
function getAndSetData() { getData().then(res => setData(res.data.data)) }
function getData() { return axios.get(`${apiUrl}/users`) }
function setData(data) {
    return store.dispatch("changeData", data)
}


export default allData;

