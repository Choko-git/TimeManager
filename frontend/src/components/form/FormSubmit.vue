<template>
  <div class="form-submit">
    <span class="form-error">{{ error }}</span>
    <div class="form-submit-button">
      <ButtonSubmit :disabled="buttonDisabled" :name="buttonName" :loading="loading" />
    </div>
  </div>
</template>

<script>
import ButtonSubmit from "../button/ButtonSubmit";

export default {
  props: ["buttonName", "loading", "error", "buttonDisabled"],
  components: {
    ButtonSubmit,
  },
};
</script>

<style lang="scss">
.form-submit {
  margin-top: 10px;
  @include flex-container-column;
  & .form-error {
    color: red;
    height: 25px;
    width: 100%;
    margin-bottom: 5px;
    padding-left: 5px;
  }
  & .form-submit-button {
    display: flex;
    & button {
      margin: auto 0 auto auto;
    }
  }
}
</style>