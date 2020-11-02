<template>
  <button class="button button" @click.stop="$emit('mouse-event')">{{ name }}</button>
</template>

<script>
export default {
  props: ["name"],
};
</script>