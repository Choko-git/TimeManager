<template>
  <donut-chart
    id="donut"
    :data="donutData"
    colors='["#FF6384", "#36A2EB"]'
    resize="true">
  </donut-chart>

</template>

<script>
import { DonutChart } from 'vue-morris';
import Raphael from 'raphael/raphael';
import jQuery from 'jquery';

global.Raphael = Raphael
global.jQuery = jQuery

export default {
  data: function() {
    return {
    donutData: [
      { label: 'On work', value: 300},
      { label: 'Off work', value: 50},
    ]
    };
  },
  components: { DonutChart }
}
</script>