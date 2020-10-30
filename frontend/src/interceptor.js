import axios from 'axios';

export default function setup() {
    axios.interceptors.request.use(function (config) {
        // config.headers.withCredentials = true   
        const token = localStorage.getItem('token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }   
        return config;
    }, function (err) {
        return Promise.reject(err);
    });
}