<template>
  <select
    class="select-input"
    v-model="field.value"
    @change="change"
    :style="{ color: field.value === '' ? 'grey' : 'black' }"
  >
    <option value="" hidden class="select-placeholder">
      {{ field.placeholder }}
    </option>
    <option
      v-for="option in field.options"
      :value="option.value"
      :key="option.name"
    >
      {{ option.name }}
    </option>
  </select>
</template>

<script>
export default {
  props: ["field", "changeMethod"],
  methods: {
    change(){
      this.changeMethod();
      this.$forceUpdate();
    }
  }
};
</script>