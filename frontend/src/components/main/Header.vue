<template>
  <div v-if="user" id="header">
    <div id="header-left">
      <div id="username">
        <span>{{ user.username }}</span>
      </div>
    </div>
    <div id="header-center">
      <div id="today">
        <span>{{ today }}</span>
      </div>
    </div>
    <div class="header-right">
      <div id="notifications">
        <SetButtonDropDown
          buttonType="ButtonImage"
          buttonIcon="bell"
          buttonName="Notifications"
          dropDownType="DropDownList"
          :dropDownData="[{ name: 'No Notification' }]"
          dropDownWidth="200px"
        />
      </div>
      <div id="settings">
        <SetButtonDropDown
          buttonType="ButtonRoll"
          buttonIcon="settings"
          buttonName="Settings"
          dropDownType="DropDownList"
          :dropDownData="[{ name: 'Log Out', icon: 'sign-out', method: logOutAndRedirect }]"
          dropDownWidth="120px"
        />
      </div>
    </div>
  </div>
</template>


<script>
import { mapState } from "vuex";
import SetButtonDropDown from "../../components/sets/SetButtonDropDown";
import moment from "moment";
import { logOutAndRedirect } from "@/modules/auth-manager";

export default {
  data: function () {
    return {
      today: moment().format("LL"),
    };
  },
  components: {
    SetButtonDropDown,
  },
  computed: mapState({
    user: (state) => (state.auth.isAuth ? state.auth.user : null),
  }),
  methods: { logOutAndRedirect },
};
</script>

<style lang="scss">
#header {
  position: relative;
  @include flex-container;
  padding: 0 20px;
  justify-content: space-between;
  & #header-left {
    display: flex;
    & #username {
      padding: 10px;
      background-color: rgb(200, 200, 200);
      border-radius: 15px;
      border: $classic-border;
      box-shadow: $main-shadow;
      font-weight: 600;
      margin: auto 0;
    }
  }
  & #header-center {
    position: absolute;
    right: 50%;
    transform: translate(50%, 50%);
    #today {
      font-size: 18px;
      color: white;
      font-size: 22px;
    }
  }
  & .header-right {
    display: flex;
    width: 250px;
    justify-content: space-between;
    & #notifications {
      display: flex;
    }
    & #settings {
      margin: auto 0;
    }
  }
}
</style>
