<template>
  <button class="button button" v-on:click="clock" > {{name}} </button>
</template>

<script>
export default {
    props:[
        "name"
    ],
    methods: { 
        clock: function() {
            return this.$emit("send");
        },
    }
};
</script>