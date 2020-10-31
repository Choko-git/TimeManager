<template>
  <button class="submit-button" type="submit">
    {{ name }}
  </button>
</template>

<script>
export default {
  props: ["name"],
};
</script>

<style lang="scss">
.submit-button {
  background-color: $main-color-2;
  color: white;
  border: $classic-border;
  width: 100px;
  padding: 5px;
}
</style>