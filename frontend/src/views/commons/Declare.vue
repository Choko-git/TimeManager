<template>
  <div id="declare">
    <div id="page-content">
      <h1>Clocking of the day</h1>
      <FormClassic
        submitButtonName="Submit"
        :formSubmitMethod="setData"
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
  </div>
</template>

<script>
import FormClassic from "@/components/form/FormClassic";
import { authAndRedirect } from "@/modules/auth-manager";
import { mapState } from "vuex";

export default {
  components: { FormClassic },
  data: function () {
    return {
      start: null,
      break_time: null,
      end: null,
      total_time: null,
      status: null,
      error: null,
    };
  },
  computed: mapState({
    user: (state) => (state.auth.isAuth ? state.auth.user : null),
  }),
  methods: { authAndRedirect,
    setData: function (formData) {
      var _start = new Date().toJSON().slice(0,10) + " " + formData.start + ":00"
      var _end = new Date().toJSON().slice(0,10) + " " + formData.end + ":00";
      if (new Date(_start).getHours() > new Date(_end).getHours()) {
        var current = new Date()
        _end = new Date(current.getTime() + 86400000).toJSON().slice(0,10) + " " + formData.end + ":00";
      }
      var _total_time = new Date(_end).getTime() - new Date(_start).getTime()
      _total_time -= (+(formData.break_time.split(":"))[0] * (60000 * 60))
      console.log(this.user.id, _start, _total_time, _end)
      return {
        user_id: this.user.id,
        start: _start,
        total_time: _total_time,
        end: _end,
        status: false,
      }
    }
  },
};

</script>
