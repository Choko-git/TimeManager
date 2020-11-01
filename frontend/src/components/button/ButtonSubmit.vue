<template>
  <button
    class="submit-button"
    type="submit"
    :disabled="disabled"
    v-bind:class="{ loading }"
  >
    <span v-if="!loading">{{ name }}</span>
    <span v-else class="loader"></span>
  </button>
</template>

<script>
export default {
  props: ["name", "loading", "disabled"],
};
</script>

<style lang="scss">
.submit-button {
  transition: opacity .2s;
  background-color: $main-color-2;
  color: white;
  border: $classic-border;
  height: 40px;
  width: 100px;
  padding: 0px;
  &:focus {
    outline: none;
  }
  &.loading {
    display: flex;
    margin: 0;
    & .loader {
      display: inline-block;
      width: 25px;
      height: 25px;
      margin: auto;
      &:after {
        content: "";
        display: block;
        width: 25px;
        height: 25px;
        border-radius: 100px;
        border: 2px solid;
        border-color: $main-color-3 transparent;
        animation: lds-dual-ring 1.7s linear infinite;
      }
    }
    &:hover {
      cursor: wait !important;
      opacity: .95 !important;
    }
  }
  &:disabled {
    opacity: 0.7;
  }
}

@keyframes lds-dual-ring {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>