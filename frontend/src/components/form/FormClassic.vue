<template>
  <form class="classic-form" @submit.prevent="submitForm">
    <div class="form-field" v-for="field of fields" :key="field.name">
      <div
        v-if="!field.notHere"
        class="m-0"
        :class="{ hidden: field.if && !field.display }"
      >
        <label v-if="field.label">{{ field.label }}</label>
        <TextInput
          v-if="!['select', 'autoComplete'].includes(field.type)"
          :field="field"
          :changeMethod="fieldChange"
        />
        <SelectInput
          v-else-if="field.type === 'select'"
          :field="field"
          :changeMethod="fieldChange"
        />
        <AutoCompleteInput
          v-else
          :field="field"
          :disabled="field.disabled"
          :placeholder="field.placeholder"
          keyToShow="username"
          :dropDown="true"
          :array="field.array"
          :noDataText="field.noDataText"
          @searchData="searchData($event, field)"
          @dataSelected="selectData($event, field)"
          @dataDeleted="dataDeleted"
        />
      </div>
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
import TextInput from "@/components/inputs/TextInput";
import SelectInput from "@/components/inputs/SelectInput";
import AutoCompleteInput from "@/components/inputs/AutoCompleteInput";
import errorHandler from "@/modules/error-handler";
import { checkText, checkEmail } from "@/modules/field-checker";
import { apiUrl } from "@/env-config";
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
    TextInput,
    SelectInput,
    AutoCompleteInput,
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
    searchData(event, field) {
      field.value = null;
      field.dataToSelect = field.searchData(event);
    },
    selectData(event, field) {
      field.value = event.id;
      if (field.change) {
        field.change(field, this.fields);
      }
      this.fieldChange();
    },
    getCheckFieldFromType(type) {
      switch (type) {
        case "text":
          return checkText;
        case "email":
          return checkEmail;
        default:
          return null;
      }
    },
    dataDeleted(){
      this.checkRequiredFields()
    },
    fieldChange() {
      this.fields.forEach((field) => {
        if (field.if) {
          field.display = field.if(this.fields);
        }
        if (field.disabledMethods) {
          field.disabled = field.disabledMethods();
        }
      });
      this.checkRequiredFields();
      this.$forceUpdate();
    },
    checkRequiredFields() {
      this.buttonDisabled =
        this.fields.filter((field) => {
          let value = field.value;
          if (value && field.checkFieldMethod) {
            value = field.checkFieldMethod(value, field);
          }
          const fieldNotDisplay = field.if && !field.display;
          const check =
            !value &&
            field.required !== false &&
            !fieldNotDisplay &&
            !field.notHere;
          field.redBorder = check && value !== undefined && value !== "";
  
          return check;
        }).length > 0;
    },
    submitForm: function () {
      if (!this.loading) {
        this.loading = true;
        let formData = {};
        this.fields.forEach((_) => (formData[_.name] = _.value));
        if (this.formSubmitMethod) {
          formData = this.formSubmitMethod(formData);
        }
        const url = `${apiUrl}${this.apiRoute}`;
        axios[this.httpMethod](url, formData)
          .then((res) => {
            this.formValidMethod(res);
            this.$emit("closeForm");
            setTimeout(() => {
              this.loading = false;
            });
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
      transition: all 0.5s;
      opacity: 1;
      margin-top: 20px;
    }
    & input {
      @include classic-input;
    }
    & select {
      @include classic-select-input;
      & option {
        color: black;
      }
    }
    & .hidden {
      opacity: 0;
      pointer-events: none;
    }
  }
}
</style>