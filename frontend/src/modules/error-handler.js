import { logOutAndRedirect } from "@/modules/auth-manager";

const errorHandler = function (err) {
    switch (err?.status) {
        case undefined: return "The server doesn't respond";
        case 401: return logOutAndRedirect();
        case 500: return "500 : Server Error";
        default: return err.data
    }
}

export default errorHandler;