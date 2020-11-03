<template>
  <div class="set-button-dropdown">
    <component
      :is="Button"
      @mouse-event="activeDropDown($event)"
      :active="dropDownActive"
      :icon="buttonIcon"
      :name="buttonName"
    ></component>
    <component
      :is="DropDown"
      :active="dropDownActive"
      @mouse-event="activeDropDown($event)"
      :data="dropDownData"
      :width="dropDownWidth"
      :height="dropDownHeight"
      :httpMethod="dropDownFormHttpMethod"
      :apiRoute="dropDownFormApiRoute"
      :fields="dropDownFormFields"
      :mouseEvent="dropDownMouseEvent"
      :formSubmitMethod="formSubmitMethod"
      :formValidMethod="formValidMethod"
      :formSubmitButtonName="formSubmitButtonName"
    />
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      mouseOnDropDown: false,
      dropDownActive: false,
    };
  },
  props: [
    "count",
    "buttonType",
    "buttonIcon",
    "buttonName",
    "dropDownEvent",
    "dropDownType",
    "dropDownData",
    "dropDownFormFields",
    "dropDownFormHttpMethod",
    "dropDownFormApiRoute",
    "dropDownMouseEvent",
    "dropDownWidth",
    "dropDownHeight",
    "formSubmitButtonName",
    "formSubmitMethod",
    "formValidMethod",
    "noDataText"
  ],
  mounted() {
    if (this.dropDownEvent === "click") {
      document.addEventListener("mousedown", this.closeDropDown);
    }
  },
  computed: {
    Button() {  
      return () => import(`../../components/button/${this.buttonType}`);
    },
    DropDown() {
      return () => import(`../../components/drop-down/${this.dropDownType}`);
    },
  },
  methods: {
    closeDropDown: function () {
      this.dropDownActive = false;
    },
    activeDropDown: function (value = null) {
      if (this.dropDownEvent === "click") {
          this.dropDownActive = !this.dropDownActive;
        } else {
        this.mouseOnDropDown = value;
        if (value) this.dropDownActive = value;
        else {
          setTimeout(() => {
            this.dropDownActive = this.mouseOnDropDown;
          }, 150);
        }
      }
    },
  },
};
</script>

<style lang="scss">
.set-button-dropdown {
  display: flex;
  justify-content: center;
  position: relative;
  opacity: 1;
}
</style>