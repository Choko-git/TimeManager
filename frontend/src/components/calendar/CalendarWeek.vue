<template>
  <div id="workingtimes_array">
    <v-table
      row-click-color="#edf7ff"
      :border="bord"
      :auto-width="autoWidth"
      :width="1400"
      :columns="columns"
      :table-data="tableData"
      :show-vertical-border="false"
      :pagination="{
        itemsPerPage: 1,
        align: 'center',
        visualStyle: 'select'
      }"
    ></v-table>
  </div>
</template>

<script>
import { mapState } from "vuex";
import Grid from "vue-js-grid";
import Vue from "vue";
import { VTable, VPagination } from "vue-easytable";

Vue.component(VTable.name, VTable);
Vue.component(VPagination.name,VPagination);
Vue.use(Grid);

export default {
  data: function () {
    return {
      tableData: [],
      columns: [
        {
          width: 60,
          titleAlign: "center",
          columnAlign: "center",
          type: "selection"
        },
        {
          field: "date",
          title: "Date",
          width: 100,
          titleAlign: "center",
          columnAlign: "center"
        },
        {
          field: "start",
          title: "Start",
          width: 260,
          titleAlign: "center",
          columnAlign: "center"
        },
        {
          field: "end",
          title: "End",
          width: 150,
          titleAlign: "center",
          columnAlign: "center"
        }
      ],
      autoWidth: true,
      pagination: true,
      pageIndex: 1,
      pageSize: 10,
      total: 2,
      bord: true,
    };
  },
  methods: {
  },
  created: function() {
    this.allData = this.$store.state.data;
    var workingtimes_array = this.allData.workingtimes
    var new_workingtimes = []
    for (var i = 0; i < workingtimes_array.length; i++) {
      new_workingtimes.push({
      date: workingtimes_array[i].start.split(/[T|" "]/)[0],
      start: workingtimes_array[i].start.split(/[T|" "]/)[1],
      end: workingtimes_array[i].end.split(/[T|" "]/)[1],
      })
    }
    new_workingtimes.sort(function(a,b){
      return new Date(a.date) - new Date(b.date);
    });
    this.tableData = new_workingtimes
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