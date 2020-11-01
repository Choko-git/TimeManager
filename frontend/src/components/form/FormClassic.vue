<template>
  <form class="classic-form" @submit.prevent="submitForm">
    <div class="form-field" v-for="field of fields" :key="field.name">
      <label v-if="field.label">{{ field.label }}</label>
      <input
        :type="field.type"
        v-model="field.value"
        :placeholder="field.placeholder"
        @keyup="checkRequiredFields"
      />
    </div>
    <FormSubmit
      :buttonName="submitButtonName"
      :loading="loading"
      :error="error"
      :buttonDisabled="buttonDisabled"
    />
  </form>
</template>

<script>
import FormSubmit from "@/components/form/FormSubmit";
import errorHandler from "@/modules/error-handler";
import { checkText, checkEmail } from "@/modules/field-checker";

import axios from "axios";

export default {
  data: () => ({
    loading: false,
    error: null,
    buttonDisabled: false,
  }),
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
  created: function () {
    this.fields.forEach((_) => {
      _.required = _.required === false ? false : true;
      _.checkFieldMethod =
        _.checkFieldMethod || this.getCheckFieldFromType(_.type);
    });
    this.checkRequiredFields();
  },
  methods: {
    getCheckFieldFromType(type) {
      switch (type) {
        case "text": return checkText;
        case "email" : return checkEmail;
        default: return null;
      }
    },
    checkRequiredFields() {
      this.buttonDisabled = this.fields.find((field) => {
        let value = field.value;
        if (value && field.checkFieldMethod) {
          value = field.checkFieldMethod(value);
        }
        return !value && field.required;
      });
    },
    submitForm: function () {
      if (!this.loading) {
        this.loading = true;
        let formData = {};
        this.fields.forEach((_) => (formData[_.name] = _.value));
        if (this.formSubmitMethod) {
          formData = this.formSubmitMethod(formData);
        }
        const url = `http://localhost:4000/api${this.apiRoute}`;
        axios[this.httpMethod](url, formData)
          .then((res) => {
            this.formValidMethod(res);
            setTimeout(() => (this.loading = false));
          })
          .catch((err) => {
            this.loading = false;
            this.error = errorHandler(err.response);
          });
      }
    },
  },
};
</script>

<style lang="scss">
.classic-form {
  @include flex-container-column;
  & .form-field {
    & * {
      margin-top: 20px;
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