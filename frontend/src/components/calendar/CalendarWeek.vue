<template>
    <h1>CALENDARA</h1>
</template>

<script>
import { mapState } from "vuex";

export default {
  data: function () {
    return {
    };
  },
  created: function() {
    this.allData = this.$store.state.data;
    console.log(this.allData)
  },
  computed: mapState({
    user: (state) => (state.auth.isAuth ? state.auth.user : null),
  }),
  watch: {
    "$store.state.data": function (data) {
    this.allData = data
    },
  },
}
</script>