<template>
  <donut-chart
    id="donut"
    :data="donutData"
    colors='["#FF6384", "#FF6384", "#FF6384"]'
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
      { label: 'Red', value: 300},
      { label: 'Blue', value: 50},
      { label: 'Yellow', value: 100},
    ]
    };
  },
  components: { DonutChart }
}
</script>