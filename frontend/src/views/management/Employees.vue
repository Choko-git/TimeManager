<template>
  <div id="employees">
    <div class="page-title">
      <h1>Employees</h1>
    </div>
  </div>
</template>


<script>
import axios from "axios";

export default {
  created: function () {
      this.getEmployees();
  },
  methods: {
    getEmployees: function () {
      axios.get(`http://localhost:4000/api/users`)
      .then(res => console.log(res));
    },
  },
};
</script>


<style lang="scss">
#employees {
  @include page;
}
</style>