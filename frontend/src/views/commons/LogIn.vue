<template>
  <div id="log-in">
    <button id="sign_up-button" @click="() => signUp = true">Sign Up</button>
    <div v-if="signUp" id="clock-popup">
      <DropDownForm
        formSubmitButtonName="Submit"
        :formSubmitMethod="beforeSign"
        :formValidMethod="afterSign"
        httpMethod="post"
        width="400px"
        height="280px"
        active="true"
        apiRoute="/users/sign_up"
        :fields="[
          { name: 'username', placeholder: 'Username', type: 'username' },
          { name: 'email', placeholder: 'Email', type: 'email' },
          { name: 'password', placeholder: 'Password', type: 'password' },
        ]"
      />
    </div>
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
import DropDownForm from "@/components/drop-down/DropDownForm";
export default {
  components: { FormClassic, DropDownForm },
  data: function () {
    return {
      email: null,
      password: null,
      error: null,
      signUp: false,
    };
  },
  methods: {
    authAndRedirect,
    beforeSign(data) {
      data.role = 'admin'
      return data
    },
    afterSign() {
      this.signUp = false;
    },
  },
};
</script>

<style lang="scss">
#log-in {
  @include classic-card;
  display: flex;
  flex-direction: column;
  width: 350px;
  margin: auto;
  transform: translateY(-25%);
  position: relative;

  & #clock-popup {
    height: 100%;
    width: 100%;
    position: absolute;
    z-index: 50;
    & .form-dropdown {
      top: 20%;
      left: 50%;
      transform: translateX(-50%);
    }
    & #page-content {
      @include flex-container-column;
      margin: auto;
      & h1 {
        margin: 0;
        font-size: 30px;
      }
    }
  }
}
</style>
