<template>
  <div id="notifications-button">
    <img
      @mouseover="onMouseEvent(true)"
      @mouseleave="onMouseEvent(false)"
      src="../../assets/icons/bell.svg"
      alt="notifications"
    />
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      mouseHover: false,
    };
  },
  props: ["active"],
  methods: {
    onMouseEvent: function (value) {
      this.$emit("mouseEvent", value);
    },
  },
  watch: {
    active: function (value) {
      this.onMouseEvent(value);
    },
  },
};
</script>

<style lang="scss">
#notifications-button {
  cursor: pointer;
  margin: auto 0;
  width: 30px;
  height: auto;
  transition: opacity 0.3s;
  &:hover {
    opacity: .5;
  }
}
</style>
