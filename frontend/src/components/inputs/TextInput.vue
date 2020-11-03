<template>
  <input
    class="text-input"
    :type="field.type"
    :class="{ redBorder: !focusIn && field.redBorder }"
    v-model="field.value"
    :placeholder="field.placeholder"
    @change="changeMethod(field)"
    @keyup="changeMethod(field)"
    @focus="changeFocus(true)"
    @blur="changeFocus(false)"
  />
</template>

<script>
export default {
  data: () => ({
    focusIn: false,
  }),
  created: ()=> {
    console.log('ojoj');
  },
  props: ["field", "changeMethod"],
  methods: {
    changeFocus(value){
      this.focusIn = value;
    }
  }
};
</script>

<style lang="scss">
.redBorder {
  border-color: rgba(255, 0, 0, 0.623) !important;
}
</style>