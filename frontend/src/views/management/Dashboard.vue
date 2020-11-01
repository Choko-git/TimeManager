<template>
  <div id="content">
    <div id="middle">
      <Donut />
    </div>
    <div id="right">
      <Bar />
    </div>
  </div>
</template>

<script>
import Donut from "../../components/chart/Donut"
import Bar from "../../components/chart/Bar"

export default {
    components: {
        Donut,
        Bar,
    },
};
</script>