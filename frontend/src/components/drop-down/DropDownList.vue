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
  props: ["active", "data", "width", "mouseEvent"],
  methods: {
    activeDropDown: function (value) {
      if (this.mouseEvent) {
        this.$emit("mouse-event", value);
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
.list-dropdown {
  @include listDropDown
}
</style>