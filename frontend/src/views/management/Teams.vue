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
              if: (data) => this.role === 'admin',
            },
          ]"
          dropDownFormHttpMethod="post"
          dropDownFormApiRoute="/users"
          dropDownWidth="300px"
          :dropDownHeight="role === 'admin' ? '410px' : '250px'"
          :formSubmitMethod="beforeCreated"
          :formValidMethod="() => {}"
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
    listColumns: null,
    sortIndex: 1,
    sortOrder: 1,
    regExp: null,
  }),
  components: {
    ListClassic,
    SetButtonDropDown,
  },
  created: function () {
    this.setColumns();
    this.setTeamsData(this.$store.state.data);
  },
  computed: mapState({
    role: (state) => (state.auth.isAuth ? state.auth.user.role : null),
  }),
  watch: {
    "$store.state.data": function (data) {
      this.setTeamsData(data);
    },
  },
  methods: {
    beforeCreated(data) {
      if (data.role === "manager") {
        data.surpervisor_id = null;
      }
      return data;
    },
    searchManager: function (value) {
      if (value) {
        const regExp = new RegExp(
          value.toLowerCase().trim().replace(/\s+/g, "").split("").join(" *")
        );
        return this.employeesData.filter((_) => {
          return _.role === "manager" && regExp.test(_.username.toLowerCase());
        });
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
      data?.forEach((manager) => {
        manager.employees?.forEach((employee) => {
          this.checkEmployeeTeams(employee, manager);
        });
      });
    },
    setTeams(data) {
      data?.forEach((employee) => {
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
  & #create-employee {
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