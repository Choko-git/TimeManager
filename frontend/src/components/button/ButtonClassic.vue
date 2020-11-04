<template>
  <button class="button-classic" @click.stop="$emit('mouse-event')">
    {{ name }}
  </button>
</template>

<script>
export default {
  props: ["name"],
};
</script>

<style lang="scss">
.button-classic {
  padding: 7px 13px;
  color: $main-color-1;
  border-radius: 10px;
  background-color: $light-grey;
  border: none;
  box-shadow: $button-shadow;
  border: $grey-slight-border;
  opacity: 1;
  transition: all .25s;
  &:hover {
    opacity: 0.9;
    background-color: $lighter-grey;
    color: $darker-grey;
  }
  &:focus {
    outline: none;
  }
}
</style>