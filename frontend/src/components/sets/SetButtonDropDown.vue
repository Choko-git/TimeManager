<template>
  <div class="set-button-dropdown">
    <component
      :is="Button"
      v-on:mouseEvent="activeDropDown($event)"
      :active="dropDownActive"
      :icon="buttonIcon"
      :name="buttonName"
    ></component>
    <component
      :is="DropDown"
      :active="dropDownActive"
      v-on:mouseEvent="activeDropDown($event)"
      :data="dropDownData"
      :width="dropDownWidth"
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
    "dropDownType",
    "dropDownData",
    "dropDownWidth",
    "noDataText",
  ],
  computed: {
    Button() {
      return () => import(`../../components/button/${this.buttonType}`);
    },
    DropDown() {
      return () => import(`../../components/drop-down/${this.dropDownType}`);
    },
  },
  methods: {
    activeDropDown: function (value) {
      this.mouseOnDropDown = value;
      if (value) this.dropDownActive = value;
      else {
        setTimeout(() => {
          this.dropDownActive = this.mouseOnDropDown;
        }, 150);
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