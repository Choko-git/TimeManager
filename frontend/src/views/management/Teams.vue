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
              noDataText: 'No user found',
              dataToSelect: [],
              searchData: searchManager,
              notHere: role !== 'admin',
              change: managerSelected
            },
            {
              name: 'user_ids',
              placeholder: 'Choose employees',
              type: 'autoComplete',
              noDataText: 'No user found',
              dataToSelect: [],
              array: true,
              searchData: searchEmployee,
              disabled: (role === 'admin' && !selectedManager.id),
              listValue: selectedEmployees,
              listKey: 'username',
              change: employeeSelected,
              deleteMethod: employeeDeleted
            },
          ]"
          dropDownFormHttpMethod="post"
          dropDownFormApiRoute="/users"
          dropDownWidth="300px"
          :dropDownHeight="role === 'admin' ? '350px' : '210px'"
          :formSubmitMethod="beforeCreated"
          :formValidMethod="teamCreated"
        />
      </div>

      <!-- <div id="search-field">
        <AutoCompleteInput
          placeholder="Search an employee ..."
          keyToShow="username"
          @searchData="addRegExp($event)"
          @dataSelected="changeUser($event)"
        />
      </div> -->
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

export default {
  data: () => ({
    teamsData: [],
    managersData: [],
    listColumns: null,
    sortIndex: 1,
    sortOrder: 1,
    regExp: null,
    selectedManager: {},
    selectedEmployees: [],
  }),
  components: {
    ListClassic,
    SetButtonDropDown,
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
    managerSelected(field) {
      this.selectedEmployees.length = 0;
      this.selectedManager.id = field.value;
      console.log(this.selectedManager);
      // this.$forceUpdate();
    },
    employeeSelected(field) {
      this.selectedEmployees.push(
        this.employeesData.find((_) => _.id === field.value)
      );
    },
    employeeDeleted(data){
      const index = this.selectedEmployees.findIndex( _ => _ === data);
      this.selectedEmployees.splice(index, 1);
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
      console.log(data);
      // const user = data.data;
      // const me = this.$store.state.data;
      // if (user.surpervisor_id === me.id) {
      //   me.employees.push(user);
      // } else {
      //   me.employees = me.employees.data((manager) => {
      //     if (manager.id === user.id) {
      //       manager.employees.push(user);
      //     }
      //   });
      // }
      // store.dispatch("changeData", me);
      // this.initData();
    },
    beforeCreated(data) {
      console.log(data);
    },
    createRegExp(value) {
      return new RegExp(
        value.toLowerCase().trim().replace(/\s+/g, "").split("").join(" *")
      );
    },
    filterWithRegexp(regExp, array, condition = () => true) {
      return array
        .filter((_) => {
          return condition(_) && regExp.test(_.username.toLowerCase());
        })
        .splice(0, 10);
    },
    searchEmployee(value) {
      if (value) {
        const regExp = this.createRegExp(value);
        return this.filterWithRegexp(regExp, this.employeesData, (data) => {
          return (
            this.selectedEmployees.findIndex((_) => _ === data) === -1 &&
            data["surpervisor_id"] === this.selectedManager.id
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
      console.log(data);
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
      this.role === "admin"
        ? this.setTeamsByManager(data)
        : this.setTeamsDataList(data);
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
    checkEmployeeTeams(employee, manager) {
      employee.teams?.forEach((team) => {
        const teamData = this.teamsData.find((_) => _.id === team.id);
        if (teamData) {
          teamData.rows[2].value++;
        } else {
          const rows = [{ value: team.name }, { value: 1 }];
          if (manager) {
            rows.push({ value: manager.username });
          }
          teamData.push({
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