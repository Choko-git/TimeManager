<template>
  <div id="employees">
    <div class="content">
      <div class="page-title">
        <h1>Employees</h1>
      </div>

      <div id="search-field">
        <AutoCompleteField
          placeholder="Search an employee ..."
          keyToShow="username"
          v-on:searchData="addRegExp($event)"
          v-on:dataSelected="changeUser($event)"
        />
      </div>
      <div v-if="employeesListData" id="employees-list">
        <ListClassic
          :data="employeesListData"
          :columns="listColumns"
          @sort="sortEvent($event)"
          @invert="invertList($event)"
          noDataText="You have no employee yet"
          noResultText="No employee found"
        />
      </div>
    </div>
  </div>
</template>


<script>
import ListClassic from "@/components/list/ListClassic";
import AutoCompleteField from "@/components/inputs/AutoCompleteField";

import { mapState } from "vuex";

export default {
  data: () => ({
    employeesData: null,
    listColumns: null,
    employeesListData: null,
    sortIndex: 1,
    sortOrder: 1,
    selectedDate: new Date(),
    regExp: null,
  }),
  components: {
    ListClassic,
    AutoCompleteField,
  },
  created: function () {
    const allData = this.$store.state.data?.data;
    this.employeesData = [];
    this.flattenEmployees(this.employeesData, allData);
    this.setWholeTable();
  },
  computed: mapState({
    role: (state) => (state.auth.isAuth ? state.auth.user.role : null),
  }),
  watch: {
    "$store.state.data": function () {
      const allData = this.$store.state.data?.data;
      this.employeesData = [];
      this.flattenEmployees(this.employeesData, allData);
      this.setWholeTable();
    },
  },
  methods: {
    addRegExp: function(value){
        this.regExp = new RegExp(value.toLowerCase().trim().replace(/\s+/g, '').split('').join(' *'));
        this.searchUsers();
    },
    searchUsers: function () {
      this.employeesListData = [];
      this.filterFlatData().forEach((_) => this.formatRow(_));
      this.employeesListData = this.employeesListData.sort((a, b) => {
        return this.sortList(a, b);
      });
    },
    filterFlatData: function () {
      return this.employeesData.filter((_) => {
        return this.checkRegExp(_.username);
      });
    },
    flattenEmployees: function (array, employees = this.employeesData) {
      if (employees) {
        for (const employee of employees) {
          array.push({ ...employee, employees: null });
          if (employee.employees?.length) {
            this.flattenEmployees(array, employee.employees);
          }
        }
      }
    },
    checkRegExp: function (value) {
      return this.regExp ? this.regExp?.test(value.toLowerCase()) : true;
    },
    selectUser: function () {},
    setWholeTable: function () {
      if (this.employeesData) {
        this.listColumns = [];
        this.setListColumns();
        this.searchUsers();
      }
    },
    setListColumns: function () {
      const defaultWidth = "200px";
      this.listColumns = [
        { name: "", width: "20px" },
        {
          name: "Members",
          width: defaultWidth,
          sortIndex: 1,
        },
        {
          name: this.role === "admin" ? "Role" : "Teams",
          width: defaultWidth,
          sortIndex: 2,
        },
      ];
    },
    setTable: function () {
      for (const employee of this.employeesListData) {
        this.formatRow(employee);
      }
    },
    formatRow: function (employee) {
      this.employeesListData.push([
        { class: "status status-present" },
        { value: employee.username },
        { value: this.formatRolesOrTeams(employee) },
      ]);
    },
    formatRolesOrTeams: function (employee) {
      if (this.role === "admin") {
        return this.formatRoles(employee.role);
      } else {
        return this.formatTeams(employee.teams);
      }
    },
    formatRoles: (role) => (role === "manager" ? "Manager" : "Employee"),
    formatTeams: function (teams) {
      console.log(teams);
      return "Alpha";
    },
    sortEvent: function (column) {
      if (this.sortIndex === column.sortIndex) {
        this.sortOrder = this.sortOrder * -1;
      } else {
        this.sortOrder = 1;
        this.sortIndex = column.sortIndex;
      }
      this.searchUsers();
    },
    sortList: function (a, b) {
      a = a[this.sortIndex].value.toLowerCase();
      b = b[this.sortIndex].value.toLowerCase();
      return a > b ? 1 * this.sortOrder : a < b ? -1 * this.sortOrder : 0;
    },

    formatClocks: function (clocks) {
      const clock = clocks?.find((_) =>
        this.isSameDay(new Date(_.start), this.selectedDate)
      );
      console.log(clock);
      return 2;
    },
    isSameDay: (d1, d2) =>
      this.checkDate(d1, d2, "getFullYear") &&
      this.checkDate(d1, d2, "getMonth") &&
      this.checkDate(d1, d2, "getDate"),
    checkDate: (d1, d2, method) => d1[method]() === d2[method](),
  },
};
</script>


<style lang="scss">
#employees {
  @include page;
  & #search-field {
    width: 250px;
  }
  & #employees-list {
    margin: 100px auto 0 auto;
    width: 800px;
  }
}
</style>