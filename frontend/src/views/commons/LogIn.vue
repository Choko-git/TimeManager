<template>
  <div id="log-in">
    <div id="page-content">
      <h1>Log In</h1>
      <FormClassic
        submitButtonName="Log In"
        :formValidMethod="authAndRedirect"
        httpMethod="post"
        apiRoute="/users/log_in"
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
import { authAndRedirect } from "@/modules/auth-manager";

export default {
  components: { FormClassic },
  data: function () {
    return {
      email: null,
      password: null,
      error: null,
    };
  },
  methods: { authAndRedirect },
};
</script>

<style lang="scss">
#log-in {
  @include classic-card;
  display: flex;
  width: 350px;
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
