const errorHandler = function (err) {
    switch (err?.status) {
        case undefined: return "The server doesn't respond";
        case 500: return "500 : Server Error";
        default: return err.data
    }
}

export default errorHandler;