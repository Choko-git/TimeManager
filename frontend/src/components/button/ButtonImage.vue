<template>
  <div class="image-button">
    <img
      @mouseover="onMouseEvent(true)"
      @mouseleave="onMouseEvent(false)"
      :src="require(`@/assets/icons/${icon}.svg`)"
      :alt="name"
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
  props: ["name", "icon", "active", "badge"],
  methods: {
    onMouseEvent: function (value) {
      this.$emit("mouse-event", value);
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
.image-button {
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
