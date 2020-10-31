<template>
  <div id="log-in">
    <div id="page-content">
      <h1>Log In</h1>
      <FormClassic
        submitButtonName="Log In"
        :formValidMethod="onUserLogged"
        httpMethod="post"
        apiRoute="users/log_in"
        :fields="[
          { name: 'email', placeholder: 'Email', type: 'email' },
          { name: 'password', placeholder: 'Password', type: 'password' },
        ]"
      />
    </div>
  </div>
</template>

<script>
import FormClassic from "@/components/form/FormClassic";

export default {
  components: { FormClassic },
  data: function () {
    return {
      email: null,
      password: null,
      error: null,
    };
  },
  methods: {
    async onUserLogged(res) {
      if (res.data) {
        localStorage.setItem("token", res.data.token);
        await this.$store.dispatch("change", {
          isAuth: true,
          user: res.data.user,
        });
        this.$router.push("/home");
      }
    },
  },
};
</script>

<style lang="scss">
#log-in {
  @include classic-card;
  display: flex;
  width: 300px;
  margin: auto;
  transform: translateY(-25%);
  & #page-content {
    @include flex-container-column;
    margin: auto;
    & h1 {
      margin: 0;
      font-size: 30px;
    }
  }
}
</style>
