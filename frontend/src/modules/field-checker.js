
const checkText = (value) => value?.trim().length > 0;
const checkEmail = (value) => /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(value);

export { checkText, checkEmail }