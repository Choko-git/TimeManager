<template>
  <div v-if="page === 'login'">
    <h1>Log In</h1>
    <form id="log-in-form" v-on:submit.prevent="logIn()">
      <input type="text" placeholder="Username" v-model="username" />
      <input type="password" placeholder="Password" v-model="password" />
      <button type="submit">Log In</button>
    </form>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "LogIn",
  data: function () {
    return {
      username: null,
      password: null,
    };
  },
  methods: {
    logIn() {
      const username = this.loginUsername;
      const password = this.loginPassword;
      const url = "http://localhost:4000/api/users/log_in";
      axios
        .post(url, { username, password })
        .then((res) => {
          localStorage.setItem("token", res.data);
          this.auth = true;
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>

<style lang="css">
</style>
