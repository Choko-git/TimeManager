<template>
  <div id="logo">
    <div id="logo-container">
      <div id="logo-gear">
        <div
          id="logo-gear-left"
          :style="{
            backgroundImage: `url(${require('@/assets/gear-logo.svg')}) `,
          }"
        ></div>
        <div
          id="logo-gear-right"
          :style="{
            backgroundImage: `url(${require('@/assets/gear-logo.svg')}) `,
          }"
        ></div>
      </div>
      <div id="logo-clock">
        <div class="logo-clock-border" id="logo-clock-border-bottom"></div>
        <div class="logo-clock-border" id="logo-clock-border-left"></div>
        <div class="logo-clock-border" id="logo-clock-border-top"></div>
        <div class="logo-clock-border" id="logo-clock-border-right"></div>
        <div id="logo-clock-minutes" :class="{ visible: loaded }"></div>
        <div id="logo-clock-hours" :class="{ visible: loaded }"></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data: () => ({
    minutes: null,
    hours: null,
    loaded: false,
  }),
  created: function () {
    const timerMethods = this.timer;
    setInterval(function () {
      timerMethods();
    }, 1000);
  },
  mounted: function () {
    this.minutes = document.getElementById(`logo-clock-minutes`);
    this.hours = document.getElementById(`logo-clock-hours`);
  },
  methods: {
    timer: function () {
      const now = new Date();
      const minutes = (now.getMinutes() / 60) * 360;
      const hours = (now.getHours() / 12) * 360;
      this.minutes.style["-webkit-transform"] =
        "translate(-50%) rotate(" + minutes + "deg)";
      this.hours.style["-webkit-transform"] =
        "translate(-50%) rotate(" + hours + "deg)";
      this.loaded = true;
      console.log(this.loaded);
    },
  },
};
</script>


<style lang="scss">
#logo {
  margin-bottom: 35px;
  @include flex-container;
  transition: all $sidemenu-transition;
  opacity: 1;
  & #logo-container {
    margin: auto;
    @include square(120px);
    position: relative;
    #logo-gear {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      @include square(180px);
      display: flex;
      justify-content: space-between;
      & div {
        background-repeat: no-repeat;
        background-size: 200%;
      }
      & #logo-gear-left {
        width: 125px;
      }
      & #logo-gear-right {
        width: 125px;
        filter: $logo-gear-right-filter;
        background-position: right 0;
      }
    }
    & #logo-clock {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%) rotate(180deg);
      @include square(85px);
      background-color: $logo-clock-bgc;
      border: $logo-clock-border;
      border-radius: 50%;
      #logo-clock-minutes,
      #logo-clock-hours {
        transition: opacity 0.5s;
        opacity: 0;
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
      }
      #logo-clock-minutes {
        width: 5px;
        height: 22px;
        left: 49%;
        border-radius: 2px;
        background-color: $logo-clock-hand;
        transform-origin: 50% 0;
      }
      #logo-clock-hours {
        width: 5px;
        height: 14px;
        left: 51%;
        border-radius: 2px;
        background-color: $logo-clock-hand;
        transform-origin: 50% 0;
      }
      & .logo-clock-border {
        position: absolute;
        background-color: $logo-clock-border-color;
        width: 10px;
        height: 8px;
        &#logo-clock-border-top {
          top: -1px;
          right: 50%;
          transform: translateX(50%) rotate(90deg);
        }
        &#logo-clock-border-right {
          top: 50%;
          right: -1px;
          transform: translateY(-50%);
        }
        &#logo-clock-border-bottom {
          bottom: -1px;
          right: 50%;
          transform: translateX(50%) rotate(90deg);
        }
        &#logo-clock-border-left {
          top: 50%;
          left: -1px;
          transform: translateY(-50%);
        }
      }
      & .visible {
        opacity: 1 !important;
      }
    }
  }
}
</style>