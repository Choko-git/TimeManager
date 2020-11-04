<template>
  <bar-chart
    id="bar"
    :data="barData"
    xkeys="year"
    ykeys='["and", "ios", "win"]'
    labels='["and", "ios", "win"]'
    bar-colors='["#FF6384", "#36A2EB", "FFCE56"]'
    grid="true"
    resize="true">
  </bar-chart>
</template>

<script>
import { BarChart } from 'vue-morris';
import Raphael from 'raphael/raphael';
import jQuery from 'jquery';
global.Raphael = Raphael
global.jQuery = jQuery

export default {
  data: function() {
    return {
      barData: [
        { year: '2013', and: 10, ios: 5, win: 2 },
        //{ year: '2014', and: 5, ios: 15, win: 1 },
        //{ year: '2015', and: 15,ios: 10, win: 6 },
        //{ year: '2016', and: 5, ios: 6, win: 13 },
      ]
    };
  },
  components: { BarChart }
}
</script>