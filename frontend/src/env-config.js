import * as config from "./config.json";

const apiUrl = window.cordova ? config.apiUrl.cordova : config.apiUrl.desktop

export { apiUrl }