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
        @click.stop="element.method || function(){}"
        :style="[element.icon ? {
          backgroundImage: `url(${require(`../../assets/icons/${element.icon}.svg`)})`,
        } : '']"
      >
        {{ element.name }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props: ["active", "data", "width"],
  methods: {
    activeDropDown: function (value) {
      this.$emit("mouseEvent", value);
    },
  },
};
</script>

<style lang="scss">
.list-dropdown {
  transition: all 0.5s;
  position: absolute;
  top: 50%;
  transform: translateY(50%);
  background-color: $light-grey;
  border-radius: 10px;
  box-shadow: $grey-box-shadow;
  pointer-events: none;
  opacity: 0;
  & ul {
    list-style: none;
    padding: 0 0 0 10px;
    margin: 0;
    & li {
      transition: all 0.1s;
      cursor: pointer;
      color: $darker-grey;
      border-top: $grey-slight-border;
      padding: 7px 0;
      @include bgi-right-header;
      &:hover {
        font-weight: bold;
        opacity: 0.9;
      }
    }
  }
  &.active {
    pointer-events: all;
    opacity: 1;
  }
}
</style>