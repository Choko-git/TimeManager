<template>
  <div id="log-in">
    <div id="page-content">
      <h1>Log In</h1>
      <form id="log-in-form" v-on:submit.prevent="logIn()">
        <input type="text" placeholder="Email" v-model="email" />
        <input type="password" placeholder="Password" v-model="password" />
        <button type="submit">Log In</button>
      </form>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "LogIn",
  data: function () {
    return {
      email: null,
      password: null,
    };
  },
  methods: {
    logIn() {
      const email = this.email;
      const password = this.password;
      const url = "http://localhost:4000/api/users/log_in";
      axios
        .post(url, { email, password })
        .then((res) => {
          console.log(res);
          localStorage.setItem("token", res.data.token);
          this.$store.dispatch("change", { isAuth: true, user: res.data.user });
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>

<style lang="scss">
#log-in {
  @include classic-card;
  width: 300px;
  margin: auto;
  transform: translateY(-25%);
  display: flex;
  & #page-content {
    display: flex;
    margin: auto;
    flex-direction: column;
    & h1 {
      margin: 0;
    }
    & #log-in-form {
      display: flex;
      flex-direction: column;
      & * {
        margin-top: 20px;
      }
      & input {
        padding: 5px;
        border: $classic-border;
      }
      & button {
        background-color: $main-color-2;
        color: white;
        border: $classic-border;
        width: 100px;
        padding: 5px;
      }
    }
  }
}
</style>
