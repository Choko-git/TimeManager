<template>
  <div
    v-bind:class="{ active }"
    @mouseover="activeDropDown(true)"
    @mouseleave="activeDropDown(false)"
    class="list-dropdown"
    :style="{ width }"
  >
    <ul>
      <li
        v-for="element of data"
        :key="element.name"
        :class="{redAlert: element.delete}"
        @click.stop="clickOnElement(element)"
        :style="[
          element.icon
            ? {
                backgroundImage: `url(${require(`../../assets/icons/${element.icon}.svg`)})`,
              }
            : '',
        ]"
      >
        {{ element.name }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props: ["active", "data", "width", "mouseEvent","dataToSend"],
  methods: {
    activeDropDown: function (value) {
      if (this.mouseEvent) {
        this.$emit("mouse-event", value);
      }
    },
    clickOnElement(element) {
      if (element.method) {
        element.method(this.dataToSend);
      }
    },
  },
};
</script>

<style lang="scss">
.list-dropdown {
  @include listDropDown;
  z-index: 5;
  & .redAlert{
    background-color: $error-bgc;
  }
}
</style>