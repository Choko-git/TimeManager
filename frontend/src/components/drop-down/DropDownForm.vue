<template>
  <div
    v-bind:class="{ active }"
    @mousedown.stop
    class="form-dropdown"
    :style="{ width, height }"
  >
    <FormClassic
      :submitButtonName="formSubmitButtonName"
      :formSubmitMethod="formSubmitMethod"
      :formValidMethod="formValidMethod"
      :httpMethod="httpMethod"
      :apiRoute="apiRoute"
      :fields="fields"
      @closeForm="closeDropDown"
    />
  </div>
</template>

<script>
import FormClassic from "@/components/form/FormClassic";

export default {
  components: {
    FormClassic,
  },
  props: [
    "active",
    "fields",
    "width",
    "height",
    "mouseEvent",
    "httpMethod",
    "apiRoute",
    "formSubmitButtonName",
    "formSubmitMethod",
    "formValidMethod"
  ],
  methods: {
    closeDropDown: function(){
      this.$emit("close-dropdown")
    },
    activeDropDown: function () {
      if (this.mouseEvent) {
        this.$emit("mouse-event");
      }
    },
    clickOnElement(element) {
      if (element.method) {
        element.method();
      }
    },
  },
};
</script>

<style lang="scss">
.form-dropdown {
  @include formDropDown;
}
</style>