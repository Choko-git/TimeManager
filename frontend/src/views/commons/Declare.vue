<template>
  <div id="declare">
    <div id="page-content">
      <div v-if="late_date.length == 0" id="standard_clocking">
        <h1>Clocking of the day</h1>
        <FormClassic
          submitButtonName="Submit"
          :formSubmitMethod="setDataStandard"
          :formValidMethod="authAndRedirect"
          httpMethod="post"
          apiRoute="/clocks"
          :fields="[
            { name: 'start', label: 'Start', type: 'time' },
            { name: 'break_time', label: 'Break Time', type: 'time' },
            { name: 'end', label: 'End', type: 'time' },
          ]"
        />
      </div>
      <div v-else :id="late_clocking">
        <h1>You have {{ late_date.length }} clocking late. {{ late_date }}</h1>
        <h1>{{ late_date[0][2] }}</h1>
        <FormClassic
          submitButtonName="Submit"
          :formSubmitMethod="setDataLate"
          :formValidMethod="RedirectOnDeclare"
          :httpMethod="late_date[0][0]"
          :apiRoute="late_date[0][1]"
          :fields="[
            { name: 'start', label: 'Start', type: 'time' },
            { name: 'break_time', label: 'Break Time', type: 'time' },
            { name: 'end', label: 'End', type: 'time' },
          ]"
        />
      </div>
    </div>
  </div>
</template>

<script>
import FormClassic from "@/components/form/FormClassic";
import { authAndRedirect } from "@/modules/auth-manager";
import { RedirectOnDeclare } from "@/modules/auth-manager";
import { mapState } from "vuex";

export default {
  components: { FormClassic },
  data: function () {
    return {
      late_date: [],
    };
  },
  created: async function() {
    this.allData = this.$store.state.data;
    var check = 0;
    for (var i = 0; i < this.allData.workingtimes.length; i++) {
      for (var j = 0; j < this.allData.clocks.length; j++) {
        if (new Date(this.allData.workingtimes[i].start).getDate()
          == new Date(this.allData.clocks[j].start).getDate()) {
          if (!this.allData.clocks[j].end) {
            this.late_date.push(["put", "/clocks/" + this.allData.clocks[j].id, this.allData.workingtimes[i].start])
          }
          break
        }
        check += 1
      }
      if (check == this.allData.clocks.length)
        this.late_date.push(["post", "/clocks", this.allData.workingtimes[i].start])
      check = 0
    }
  },
  watch: {
    "$store.state.data": function (data) {
      this.allData = data
    },
  },
  computed: mapState({
    user: (state) => (state.auth.isAuth ? state.auth.user : null),
  }),
  methods: { authAndRedirect, RedirectOnDeclare,
    setDataStandard: function (formData) {
      var _start = new Date().toJSON().slice(0,10) + " " + formData.start + ":00"
      var _end = new Date().toJSON().slice(0,10) + " " + formData.end + ":00";
      if (new Date(_start).getHours() > new Date(_end).getHours()) {
        var current = new Date()
        _end = new Date(current.getTime() + 86400000).toJSON().slice(0,10) + " " + formData.end + ":00";
      }
      var _total_time = new Date(_end).getTime() - new Date(_start).getTime()
      _total_time -= (+(formData.break_time.split(":"))[0] * (60000 * 60))
      return {
        user_id: this.user.id,
        start: _start,
        total_time: _total_time,
        end: _end,
        status: false,
      }
    },
    setDataLate: function (formData) {
      var reference = new Date(this.late_date[0][2])
      var _start = new Date(reference.setHours(formData.start.split(':')[0], formData.start.split(':')[1]))
      var _end = new Date(reference.setHours(formData.end.split(':')[0], formData.end.split(':')[1]))
      var _total_time = new Date(_end).getTime() - new Date(_start).getTime()
      _total_time -= (+(formData.break_time.split(":"))[0] * (60000 * 60))
      return {
        user_id: this.user.id,
        start: _start,
        total_time: _total_time,
        end:   _end,
        status: false,
      }
    }
  },
};
</script>