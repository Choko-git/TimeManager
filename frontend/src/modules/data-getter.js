import store from '@/store';
import axios from 'axios';
const allData = [];

store.watch((state) => state.auth.isAuth ? getAndSetData() : deleteData())
function deleteData() { allData.length = 0 }
function getAndSetData() { getData().then(res => setData(res.data.data)) }
function getData() { return axios.get(`http://localhost:4000/api/users`) }
function setData(data) {
    data.forEach(_ => allData.push(_))
    return store.dispatch("changeData", allData)
}


export default allData;

