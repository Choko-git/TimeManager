<!--<template>
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
import { apiUrl } from '@/env-config';

global.Raphael = Raphael
global.jQuery = jQuery

export default {
  data: function() {
    return {
    donutData: [
      { label: 'On work', value: 100},
      { label: 'Off work', value: 50},
    ],
    info: null
    };
  },
  mounted () {
    axios
      .get(`${apiUrl}/users`)
      .then(response => (this.info = response.data))
  },
  components: { DonutChart }
}
</script>