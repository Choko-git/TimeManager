<template>
  <form class="classic-form" @submit.prevent="submitForm">
    <div class="form-field" v-for="field of fields" :key="field.name">
      <label v-if="field.label">{{ field.label }}</label>
      <input
        :type="field.type"
        v-model="field.value"
        :placeholder="field.placeholder"
      />
    </div>
    <FormSubmit :buttonName="submitButtonName" />
  </form>
</template>

<script>
import FormSubmit from "@/components/form/FormSubmit";
import axios from "axios";

export default {
  props: [
    "fields",
    "submitButtonName",
    "formSubmitMethod",
    "formValidMethod",
    "httpMethod",
    "apiRoute",
  ],
  components: {
    FormSubmit,
  },
  methods: {
    submitForm: function () {
      let formData = {};
      this.fields.forEach((_) => (formData[_.name] = _.value));
      if (this.formSubmitMethod) {
        formData = this.formSubmitMethod(formData);
      }
      const url = `http://localhost:4000/api/${this.apiRoute}`;
      axios[this.httpMethod](url, formData)
        .then((res) => this.formValidMethod(res))
        .catch((err) => console.log(err));
    },
  },
};
</script>

<style lang="scss">
.classic-form {
  margin-top: 20px;
  @include flex-container-column;
  & .form-field {
    & * {
      margin-bottom: 20px;
    }
    & input {
      width: 100%;
      padding: 5px;
      border: $classic-border;
      &:focus {
        outline: $grey-slight-border;
      }
    }
  }
}
</style>