<template>
  <div id="content">
    <div id="left">
      <SideMenu />
    </div>
    <div id="right">
      <div id="top">
        <Header />
      </div>
      <div id="bottom">
        <Template />
      </div>
    </div>
  </div>
</template>


<script>
import Header from "./components/main/Header";
import SideMenu from "./components/main/SideMenu";
import Template from "./components/main/Template";
export default {
  components: {
    Header,
    SideMenu,
    Template,
  },
};
</script>

<style lang="scss">
#content {
  display: flex;
  height: 100vh;
  width: 100vw;
  & #left {
        @include sidemenu-format
  }
  & #right {
    height: 100%;
    width: 100%;
    & #top {
      width: 100%;
        @include header-format
    }
    & #bottom {
        @include template-format;
        & #template {
          height: 100%;
          display: flex;
        }
    }
  }
}
</style>
