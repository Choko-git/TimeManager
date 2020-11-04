<template>
  <div id="teams">
    <div v-if="teamData" class="content">
      <div v-if="selectedClocks" id="clock-popup">
        <DropDownForm
          formSubmitButtonName="Submit"
          :formSubmitMethod="setDataLate"
          :formValidMethod="clockUpdated"
          httpMethod="post"
          width="400px"
          height="450px"
          active="true"
          apiRoute="/clocks"
          :fields="[
            {
              name: 'start',
              label: 'Start',
              type: 'time',
              value: selectedClocks.start,
            },
            {
              name: 'break_time',
              label: 'Break Time',
              type: 'time',
              value: '01:00',
            },
            {
              name: 'end',
              label: 'End',
              type: 'time',
              value: selectedClocks.end,
            },
          ]"
        />
      </div>
      <div class="page-title">
        <h1>{{ teamData.name }}</h1>
      </div>
      <div class="top">
        <div id="update-team">
          <SetButtonDropDown
            buttonType="ButtonClassic"
            buttonName="Add an Employee"
            dropDownType="DropDownForm"
            dropDownEvent="click"
            formSubmitButtonName="Submit"
            :dropDownFormFields="[
              {
                name: 'user_id',
                placeholder: 'Choose employees',
                type: 'autoComplete',
                noDataText: 'No member found',
                dataToSelect: [],
                searchData: searchEmployee,
                listKey: 'username',
              },
            ]"
            dropDownFormHttpMethod="post"
            :dropDownFormApiRoute="`/belongs/${id}`"
            dropDownWidth="300px"
            dropDownHeight="160px"
            :formValidMethod="teamUpdated"
          />
        </div>
        <div class="working-times">
          <h2>Working Time</h2>
          <div id="select-time">
            <span id="time-left" class="arrow-time" @click="changeDate(-1)"
              >⟵</span
            >
            <span id="date">{{ displayedDate }}</span>
            <span id="time-right" class="arrow-time" @click="changeDate(1)"
              >⟶</span
            >
          </div>
        </div>
      </div>
      <div v-if="teamData" id="teams-list">
        <ListClassic
          :data="teamData.employees"
          :columns="listColumns"
          @sort="sortEvent($event)"
          @invert="invertList($event)"
          noDataText="You have no team yet"
          noResultText="No team found"
          :lastColumnButton="{
            type: 'button',
            links: [
              {
                name: 'Modify clock',
                method: modifyClock,
              },
              {
                name: 'Manage employee',
                method: seeEmployee,
              },
              {
                name: 'Remove from Team',
                method: removeEmployee,
                delete: true,
              },
            ],
          }"
        />
      </div>
    </div>
  </div>
</template>


<script>
import DropDownForm from "@/components/drop-down/DropDownForm";
import ListClassic from "@/components/list/ListClassic";
import { mapState } from "vuex";
import SetButtonDropDown from "@/components/sets/SetButtonDropDown";
import store from "@/store";
import axios from "axios";
import { apiUrl } from "@/env-config.js";
export default {
  data: () => ({
    teamData: null,
    listColumns: null,
    sortIndex: 0,
    sortOrder: 1,
    id: null,
    manager: null,
    allEmployees: [],
    selectedDate: new Date(),
    displayedDate: null,
    expectedTime: null,
    teamEmployees: [],
    selectedClocks: null,
  }),
  components: {
    ListClassic,
    SetButtonDropDown,
    DropDownForm,
  },
  created: function () {
    const data = this.$store.state.data;
    this.initData(data);
    this.displayedDate = this.formatDate(this.selectedDate);
  },
  watch: {
    "$store.state.data": function (data) {
      this.initData(data);
    },
  },
  mounted() {
    document.addEventListener("mousedown", this.closePopUp);
  },
  computed: mapState({
    role: (state) => (state.auth.isAuth ? state.auth.user.role : null),
  }),
  methods: {
    clockUpdated(data) {
      const clock = data.data.data;
      const me = this.$store.state.data;
      if (this.role === "admin") {
        const manager = me.employees.find((_) => _.id === this.manager.id);
        manager.employees = this.addOrUpdateClock(manager.employees, clock);
      } else {
        me.employees = this.addOrUpdateClock(me.employees, clock);
      }
      store.dispatch("changeData", me);
      this.selectedClocks = null;
      this.reformatClock();
    },
    addOrUpdateClock(array, clock) {
      return array.map((employee) => {
        if (employee.id === this.selectedClocks.id) {
          const old = employee.clocks.findIndex((_) => _.id === clock.id);
          if (old !== -1) {
            employee.clocks[old] = clock;
          } else {
            employee.clocks.push(clock);
          }
        }
        return employee;
      });
    },
    closePopUp() {
      this.selectedClocks = null;
    },
    modifyClock(elements) {
      const hours = elements.rows[2].value.split("-");
      this.selectedClocks = { ...elements, start: hours[0], end: hours[1] };
    },
    seeEmployee(employee) {
      const selectedObject = { id: employee.id };
      if (this.role === "admin") {
        selectedObject.manager_id = this.manager.id;
      }
      localStorage.setItem("employee", JSON.stringify(selectedObject));
      this.$router.push({ name: "Employee" });
    },
    removeEmployee(employee) {
      axios.delete(`${apiUrl}/belongs/${employee.id}/${this.id}`).then(() => {
        const me = this.$store.state.data;
        if (this.role === "admin") {
          const manager = me.employees.find((_) => _.id === this.manager.id);
          manager.employees = this.removeOfTeam(manager.employees, employee.id);
        } else {
          me.employees = this.removeOfTeam(me.employees, employee.id);
        }
        store.dispatch("changeData", me);
        this.initData(this.$store.state.data);
      });
    },
    removeOfTeam(array, employeeId) {
      return array.map((employee) => {
        if (employee.id === employeeId) {
          employee.teams = employee.teams.filter((_) => {
            return _.id !== this.id;
          });
        }
        return employee;
      });
    },
    initData(data) {
      if (data) {
        const team = JSON.parse(localStorage.getItem("team"));
        this.teamData = { name: team.name, employees: [] };
        this.id = team.id;
        if (team?.manager_id) {
          this.manager = data?.employees.find((_) => _.id === team.manager_id);
          this.allEmployees = this.manager?.employees;
        } else {
          this.manager = { ...data };
          this.allEmployees.push(...data?.employees);
        }
        this.setColumns();
        this.setTeamData();
      }
    },
    setDataLate: function (formData) {
      const clockId = this.selectedClocks.rows[2].id;
      const userId = this.selectedClocks.id;
      const reference = new Date(this.selectedDate);
      const _start = new Date(
        reference.setHours(
          formData.start.split(":")[0],
          formData.start.split(":")[1]
        )
      );
      const _end = new Date(
        reference.setHours(
          formData.end.split(":")[0],
          formData.end.split(":")[1]
        )
      );
      if (_start.getTime() > _end.getTime()) {
        _end.setDate(_end.getDate() + 1);
      }
      let _total_time = new Date(_end).getTime() - new Date(_start).getTime();
      _total_time -= +formData.break_time.split(":")[0] * (60000 * 60);
      return {
        id: clockId,
        user_id: userId,
        start: _start,
        total_time: _total_time,
        end: _end,
      };
    },
    setColumns() {
      this.listColumns = [
        { width: "40px" },
        {
          name: "Members",
          width: "310px ",
          sortIndex: 0,
        },
        {
          name: "Worked time",
          width: "400px",
        },
      ];
    },
    setTeamData() {
      this.teamData.employees.length = 0;
      this.allEmployees?.forEach((employee) => {
        if (employee.teams.find((_) => _.id === this.id)) {
          this.teamEmployees.push(employee);
          this.teamData.employees.push({
            id: employee.id,
            rows: [
              { class: "status status-present" },
              { value: employee.username },
              this.findClocks(employee.clocks),
            ],
          });
        }
      });
    },
    findClocks: function (clocks) {
      const clock = clocks?.find((_) =>
        this.isSameDay(new Date(_.start), this.selectedDate)
      );
      return this.formatClocks(clock) || { value: "No clock for this day" };
    },
    formatClocks: function (clock) {
      if (clock) {
        const start = this.formatHours(new Date(clock.start));
        let end = null;
        if (clock.end) {
          end = this.formatHours(new Date(clock.end));
        }
        return {
          value: `${start}-${end}`,
          id: clock.id,
          start: clock.start,
          end: clock.end,
        };
      }
    },
    formatHours(date) {
      let hours = date.getHours();
      hours = hours > 9 ? hours : "0" + hours;
      let minutes = date.getMinutes();
      minutes = minutes > 9 ? minutes : "0" + minutes;
      return `${hours}:${minutes}`;
    },
    reformatClock: function () {
      this.teamData.employees.forEach((employee) => {
        const current = this.teamEmployees.find((_) => _.id === employee.id);
        employee.rows[2] = this.findClocks(current.clocks);
      });
    },
    isSameDay: function (d1, d2) {
      return (
        this.checkDate(d1, d2, "getFullYear") &&
        this.checkDate(d1, d2, "getMonth") &&
        this.checkDate(d1, d2, "getDate")
      );
    },
    checkDate: (d1, d2, method) => d1[method]() === d2[method](),
    teamUpdated(data) {
      const employee = this.allEmployees.find((_) => {
        return _.id === data.data.data.user_id;
      });
      this.teamEmployees.push(employee);
      this.teamData.employees.push({
        id: employee.id,
        rows: [
          { class: "status status-present" },
          { value: employee.username },
          this.findClocks(employee.clocks),
        ],
      });
    },
    createRegExp(value) {
      return new RegExp(
        value.toLowerCase().trim().replace(/\s+/g, "").split("").join(" *")
      );
    },
    searchEmployee(value) {
      if (value) {
        const regExp = this.createRegExp(value);
        return this.filterWithRegexp(regExp, this.allEmployees, (data) => {
          return this.teamEmployees.findIndex((_) => _ === data) === -1;
        });
      } else return [];
    },
    filterWithRegexp(regExp, array, condition = () => true) {
      return array
        ?.filter((_) => {
          return condition(_) && regExp.test(_.username.toLowerCase());
        })
        .splice(0, 10);
    },
    formatDate(date) {
      const year = date.getFullYear();
      let month = date.getMonth() + 1;
      month = month > 9 ? month : "0" + month;
      let day = date.getDate();
      day = day > 9 ? day : "0" + day;
      return `${year}-${month}-${day}`;
    },
    changeDate(day) {
      this.selectedDate.setDate(this.selectedDate.getDate() + day);
      this.displayedDate = this.formatDate(this.selectedDate);
      this.reformatClock();
    },
  },
};
</script>
<style lang="scss">
#teams {
  @include page;
  & .content {
    position: relative;
    & #clock-popup {
      height: 100%;
      width: 100%;
      position: absolute;
      z-index: 50;
      & .form-dropdown {
        top: 20%;
        left: 50%;
        transform: translateX(-50%);
      }
    }
    & #search-field {
      width: 250px;
    }
    & #teams-list {
      margin: 40px auto 0 auto;
      width: 800px;
    }
    & .top {
      position: relative;
      height: 150px;
      & #update-team {
        position: absolute;
        margin: 30px 0 60px 0;
        top: 40%;
        left: 0;
        transform: translateY(-50%);
      }
      & .working-times {
        position: absolute;
        top: 50%;
        right: 50%;
        transform: translateX(50%);
        & #select-time {
          display: flex;
          width: 100%;
          justify-content: space-between;
          & * {
            font-size: 20px;
          }
        }
        & #select-time {
          display: flex;
          width: 100%;
          justify-content: space-between;
          & * {
            font-size: 20px;
          }
          & .arrow-time {
            cursor: pointer;
          }
        }
      }
    }
  }
}
</style>