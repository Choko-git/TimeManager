import * as config from "./config.json";

console.log("CORDOVA : ",window.cordova);
const apiUrl = window.cordova ? config.apiUrl.cordova : config.apiUrl.desktop;

export { apiUrl }