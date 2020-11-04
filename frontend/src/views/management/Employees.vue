<template>
  <div id="employees">
    <div class="content">
      <div class="page-title">
        <h1>Employees</h1>
      </div>
      <div id="create-employee">
        <SetButtonDropDown
          buttonType="ButtonClassic"
          buttonName="Create an employee"
          dropDownType="DropDownForm"
          dropDownEvent="click"
          formSubmitButtonName="Submit"
          :dropDownFormFields="[
            { name: 'username', placeholder: 'Username', type: 'text' },
            { name: 'email', placeholder: 'Email', type: 'email' },
            { name: 'password', placeholder: 'Password', type: 'text' },
            {
              notHere: this.role !== 'admin',
              name: 'role',
              placeholder: 'Role',
              type: 'select',
              value: '',
              options: [
                {
                  name: 'Employee',
                  value: 'employee',
                },
                {
                  name: 'Manager',
                  value: 'manager',
                },
              ],
            },
            {
              notHere: this.role !== 'admin',
              name: 'surpervisor_id',
              placeholder: 'Choose a manager',
              type: 'autoComplete',
              noDataText: 'No employee found',
              dataToSelect: [],
              searchData: searchManager,
              if: (data) => data[3].value === 'employee',
            },
          ]"
          dropDownFormHttpMethod="post"
          dropDownFormApiRoute="/users"
          dropDownWidth="300px"
          :dropDownHeight="role === 'admin' ? '410px' : '280px'"
          :formSubmitMethod="beforeCreated"
          :formValidMethod="employeeCreated"
        />
      </div>

      <div id="search-field">
        <AutoCompleteInput
          placeholder="Search an employee ..."
          keyToShow="username"
          @searchData="addRegExp($event)"
          @dataSelected="changeUser($event)"
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
          :lastColumnButton="{
            type: 'arrow',
            method: goToEmployeePage,
            allLine: true,
          }"
        />
      </div>
    </div>
  </div>
</template>


<script>
import ListClassic from "@/components/list/ListClassic";
import AutoCompleteInput from "@/components/inputs/AutoCompleteInput";
import SetButtonDropDown from "@/components/sets/SetButtonDropDown";
import { mapState } from "vuex";
import store from "@/store";

export default {
  data: () => ({
    employeesData: null,
    listColumns: null,
    employeesListData: null,
    sortIndex: 1,
    sortOrder: 1,
    regExp: null,
  }),
  components: {
    ListClassic,
    AutoCompleteInput,
    SetButtonDropDown,
  },
  created: function () {
    this.initData();
  },
  computed: mapState({
    role: (state) => (state.auth.isAuth ? state.auth.user.role : null),
  }),
  watch: {
    "$store.state.data": function () {
      this.initData();
    },
  },
  methods: {
    initData() {
      const allEmployees = this.$store.state.data?.employees || [];
      this.employeesData = [];
      this.flattenEmployees(this.employeesData, allEmployees);
      this.setWholeTable();
    },
    employeeCreated(data) {
      const user = data.data;
      const me = this.$store.state.data;
      if (user.surpervisor_id === me.id) {
        me.employees.push(user);
      } else {
        me.employees = me.employees.data((manager) => {
          if (manager.id === user.id) {
            manager.employees.push(user);
          }
        });
      }
      store.dispatch("changeData", me);
      this.initData();
    },
    goToEmployeePage(employee) {
      const selectedObject = { id: employee.id };
      localStorage.setItem("employee", JSON.stringify(selectedObject));
      this.$router.replace({ name: "Employee" });
    },
    beforeCreated(data) {
      if (data.role === "manager") {
        data.surpervisor_id = undefined;
      }
      return data;
    },
    searchManager: function (value) {
      if (value) {
        const regExp = new RegExp(
          value?.toLowerCase().trim().replace(/\s+/g, "").split("").join(" *")
        );
        return this.employeesData.filter((_) => {
          return _.role === "manager" && regExp.test(_.username?.toLowerCase());
        });
      } else return [];
    },
    addRegExp: function (value) {
      this.regExp = new RegExp(
        value?.toLowerCase().trim().replace(/\s+/g, "").split("").join(" *")
      );
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
    flattenEmployees: function (array, employees) {
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
      return this.regExp ? this.regExp?.test(value?.toLowerCase()) : true;
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
          name: "Name",
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
      this.employeesListData.push({
        id: employee.id,
        rows: [
          { class: "status status-present" },
          { value: employee.username },
          { value: this.formatRolesOrTeams(employee) },
        ],
      });
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
      a = a.rows[this.sortIndex].value?.toLowerCase();
      b = b.rows[this.sortIndex].value?.toLowerCase();
      return a > b ? 1 * this.sortOrder : a < b ? -1 * this.sortOrder : 0;
    },
  },
};
</script>


<style lang="scss">
#employees {
  @include page;
  & #create-employee {
    display: flex;
    margin: 30px 0 60px 0;
  }
  & #search-field {
    width: 250px;
  }
  & #employees-list {
    margin: 40px auto 0 auto;
    width: 800px;
  }
}
</style>