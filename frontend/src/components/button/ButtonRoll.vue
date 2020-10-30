<template>
  <button
    id="roll-btn"
    v-bind:class="{ active }"
    @mouseover="onMouseEvent(true)"
    @mouseleave="onMouseEvent(false)"
    :button-name="name"
  >
    <div class="img-container">
      <img :src="require(`@/assets/icons/${icon}.svg`)" alt="" />
    </div>
  </button>
</template>


<script>
export default {
  data: function () {
    return {
      mouseHover: false,
    };
  },
  props: ["name", "active", "icon"],
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
#roll-btn {
  margin: auto;
  z-index: 2;
  position: relative;
  background-color: transparent;
  padding: 5px 20px 5px 0;
  width: 120px;
  height: 32px;
  outline: none;
  display: flex;
  border: none;
  & .img-container {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    padding: 0 85px 0 10px;
    padding-left: 10px;
    height: 100%;
    width: 100%;
    background-color: $light-grey;
    border-radius: 100px;
    transition: 0.7s all ease;
    display: flex;
    right: 0px;
    & img {
      animation: spin 5s ease;
      width: 30px;
      margin: auto;
    }
  }

  &::before {
    transition: 2s all;
    z-index: 2;
    width: 100%;
    height: 100%;
    padding-left: 40px;
    font-weight: 700;
    color: #252525;
    opacity: 1;
    content: attr(button-name);
    font-size: 15px;
  }
  &.active {
    &::before {
      transition: 0.2s all;
      opacity: 0;
    }
    & .img-container {
      right: 1;
      padding: 0;
      width: 30px;
      & img {
        animation: spin 1s;
      }
    }
  }
  &:not(.active) {
    & .img-container {
      & img {
        animation: reverse-spin 1s;
      }
    }
  }
}

@keyframes spin {
  100% {
    transform: rotate(360deg);
  }
}

@keyframes reverse-spin {
  100% {
    transform: rotate(-360deg);
  }
}
</style>
