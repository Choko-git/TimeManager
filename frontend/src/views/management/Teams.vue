<template>
  <div id="teams">
    <div class="content">
      <div class="page-title">
        <h1>Teams</h1>
      </div>
      <div id="create-team">
        <SetButtonDropDown
          buttonType="ButtonClassic"
          buttonName="Create a team"
          dropDownType="DropDownForm"
          dropDownEvent="click"
          formSubmitButtonName="Submit"
          :dropDownFormFields="[
            { name: 'name', placeholder: 'Name', type: 'text' },
            {
              name: 'surpervisor_id',
              placeholder: 'Choose a manager',
              type: 'autoComplete',
              noDataText: 'No employee found',
              dataToSelect: [],
              searchData: searchManager,
              notHere: role !== 'admin',
              change: managerSelected,
            },
            {
              name: 'user_ids',
              placeholder: 'Choose employees',
              type: 'autoComplete',
              noDataText: 'No employee found',
              dataToSelect: [],
              array: true,
              searchData: searchEmployee,
              disabled: true,
              disabledMethods: (data) =>
                this.role === 'admin' && !this.selectedManager,
              listValue: [],
              listKey: 'username',
              change: employeeSelected,
              deleteMethod: employeeDeleted,
              checkFieldMethod: (value, field) => field.listValue.length > 0,
            },
          ]"
          dropDownFormHttpMethod="post"
          dropDownFormApiRoute="/teams"
          dropDownWidth="300px"
          :dropDownHeight="role === 'admin' ? '350px' : '280px'"
          :formSubmitMethod="beforeCreated"
          :formValidMethod="teamCreated"
        />
      </div>

      <div id="search-field">
        <AutoCompleteInput
          placeholder="Search a team ..."
          keyToShow="name"
          @searchData="addRegExp($event)"
          @dataSelected="changeUser($event)"
        />
      </div>
      <div v-if="teamsData" id="teams-list">
        <ListClassic
          :data="teamsData"
          :columns="listColumns"
          @sort="sortEvent($event)"
          @invert="invertList($event)"
          noDataText="You have no team yet"
          noResultText="No team found"
          :lastColumnButton="{
            type: 'arrow',
            method: goToTeamPage,
            allLine: true,
          }"
        />
      </div>
    </div>
  </div>
</template>


<script>
import ListClassic from "@/components/list/ListClassic";
import { mapState } from "vuex";
import SetButtonDropDown from "@/components/sets/SetButtonDropDown";
import store from "@/store";
import AutoCompleteInput from "@/components/inputs/AutoCompleteInput";

export default {
  data: () => ({
    teamsData: [],
    managersData: [],
    listColumns: null,
    sortIndex: 0,
    sortOrder: 1,
    regExp: null,
    selectedManager: null,
    selectedEmployees: [],
  }),
  components: {
    ListClassic,
    SetButtonDropDown,
    AutoCompleteInput,
  },
  created: function () {
    this.setColumns();
    this.setTeamsData(this.$store.state.data);
    this.setEmployeesData(this.$store.state.data);
  },
  computed: mapState({
    role: (state) => (state.auth.isAuth ? state.auth.user.role : null),
  }),
  watch: {
    "$store.state.data": function (data) {
      this.setTeamsData(data);
      this.setEmployeesData(data);
    },
  },
  methods: {
    managerSelected(field, fields) {
      this.selectedEmployees.length = 0;
      this.selectedManager = field.value;
      fields[2].listValue.length = 0;
    },
    employeeSelected(field) {
      this.selectedEmployees.push(
        this.employeesData.find((_) => _.id === field.value)
      );
      field.listValue = [...this.selectedEmployees];
    },
    employeeDeleted(data, field) {
      const index = this.selectedEmployees.findIndex((_) => _ === data);
      this.selectedEmployees.splice(index, 1);
      field.listValue = [...this.selectedEmployees];
    },
    setEmployeesData(data) {
      if (this.role === "admin") {
        this.managersData = data?.employees;
        this.employeesData = [];
        this.managersData?.forEach((manager) => {
          this.employeesData.push(...manager?.employees);
        });
      } else {
        this.employeesData = data?.employees;
      }
    },
    teamCreated(data) {
      const team = data.data;
      const me = this.$store.state.data;
      if (this.role === "admin") {
        const manager = me.employees.find((_) => _.id === this.selectedManager);
        manager.employees = this.addTeamInEmployees(manager.employees, team);
      } else {
        me.employees = this.addTeamInEmployees(me.employees, team);
      }
      store.dispatch("changeData", me);
      this.setTeamsData(me);
    },
    addTeamInEmployees(array, team) {
      return array.map((employee) => {
        if (team.users.map((u) => u.id).includes(employee.id)) {
          employee.teams.push(team);
        }
        return employee;
      });
    },
    beforeCreated(data) {
      data.user_ids = this.selectedEmployees.map((_) => _.id);
      return data;
    },
    addRegExp: function (value) {
      this.regExp = this.createRegExp(value);
      this.setTeamsData(this.$store.state.data);
    },
    sortEvent: function (column) {
      if (this.sortIndex === column.sortIndex) {
        this.sortOrder = this.sortOrder * -1;
      } else {
        this.sortOrder = 1;
        this.sortIndex = column.sortIndex;
      }
      this.setTeamsData(this.$store.state.data);
    },
    createRegExp(value) {
      return new RegExp(
        value.toLowerCase().trim().replace(/\s+/g, "").split("").join(" *")
      );
    },
    filterWithRegexp(regExp, array, condition = () => true) {
      return array
        ?.filter((_) => {
          return condition(_) && regExp.test(_.username.toLowerCase());
        })
        .splice(0, 10);
    },
    searchEmployee(value) {
      const condition = this.role !== "admin";
      if (value) {
        const regExp = this.createRegExp(value);
        return this.filterWithRegexp(regExp, this.employeesData, (data) => {
          return (
            this.selectedEmployees.findIndex((_) => _ === data) === -1 &&
            (condition || data["surpervisor_id"] === this.selectedManager)
          );
        });
      } else return [];
    },
    searchManager: function (value) {
      if (value) {
        const regExp = this.createRegExp(value);
        return this.filterWithRegexp(regExp, this.managersData);
      } else return [];
    },
    goToTeamPage(data) {
      const selectedObject = { id: data.id, name: data.rows[0].value };
      if (this.role === "admin") {
        selectedObject.manager_id = data.rows[2].id;
      }
      localStorage.setItem("team", JSON.stringify(selectedObject));
      this.$router.replace({ name: "Team" });
    },
    setColumns() {
      const defaultWidth = "200px";
      this.listColumns = [
        {
          name: "Name",
          width: defaultWidth,
          sortIndex: 0,
        },
        {
          name: "Members",
          width: defaultWidth,
          sortIndex: 1,
        },
      ];
      if (this.role === "admin") {
        this.listColumns.push({
          name: "Manager",
          width: defaultWidth,
          sortIndex: 2,
        });
      }
    },
    setTeamsData(data) {
      this.teamsData.length = 0;
      this.role === "admin"
        ? this.setTeamsByManager(data)
        : this.setTeams(data);
      if (this.regExp) {
        this.teamsData = this.teamsData.filter((_) => {
          return this.regExp.test(_.rows[0].value);
        });
      }
      this.teamsData = this.teamsData.sort((a, b) => {
        return this.sortList(a, b);
      });
    },
    setTeamsByManager(data) {
      this.teamsData.length = 0;
      data?.employees?.forEach((manager) => {
        manager.employees?.forEach((employee) => {
          this.checkEmployeeTeams(employee, manager);
        });
      });
    },
    setTeams(data) {
      data?.employees?.forEach((employee) => {
        this.checkEmployeeTeams(employee);
      });
    },
    sortList: function (a, b) {
      a = a.rows[this.sortIndex].value;
      b = b.rows[this.sortIndex].value;
      if (!Number.isInteger(a)) {
        a = a.toLowerCase();
        b = b.toLowerCase();
      }
      return a > b ? 1 * this.sortOrder : a < b ? -1 * this.sortOrder : 0;
    },
    checkEmployeeTeams(employee, manager) {
      employee.teams?.forEach((team) => {
        const indexTeam = this.teamsData.findIndex((_) => _.id === team.id);
        if (indexTeam !== -1) {
          this.teamsData[indexTeam].rows[1].value++;
        } else {
          const rows = [{ value: team.name }, { value: 1 }];
          if (manager) {
            rows.push({ value: manager.username, id: manager.id });
          }
          this.teamsData.push({
            id: team.id,
            rows,
          });
        }
      });
    },
  },
};
</script>


<style lang="scss">
#teams {
  @include page;
  & #create-team {
    display: flex;
    margin: 30px 0 60px 0;
  }
  & #search-field {
    width: 250px;
  }
  & #teams-list {
    margin: 40px auto 0 auto;
    width: 800px;
  }
}
</style>