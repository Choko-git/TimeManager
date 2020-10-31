<template>
  <div>
    <donut-chart
      id="donut"
      :data="donutData"
      colors='["#FF6384", "#36A2EB"]'
      resize="true">
    </donut-chart>
    <div>
      <h2>{{ info }}</h2>
    </div>
  </div>
</template>

<script>
import { DonutChart } from 'vue-morris';
import Raphael from 'raphael/raphael';
import jQuery from 'jquery';
import axios from 'axios';

global.Raphael = Raphael
global.jQuery = jQuery

export default {
  data: function() {
    var co = "On gogogl";
    return {
    donutData: [
      { label: co, value: 300},
      { label: 'Off work', value: 50},
    ],
    info: null
    };
  },
  mounted () {
    axios
      //.get('http://localhost:4000/api/users')
      .get('http://localhost:4000/api/users')
      .then(response => (this.info = response))
  },
  components: { DonutChart }
}
</script>