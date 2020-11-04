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
  }
};
</script>

<style lang="scss">
#content {
  display: flex;
  height: 100vh;
  width: 100vw;
  & #left {
    z-index: 0;
        @include sidemenu-format
  }
  & #right {
    z-index: 1;
    @include flex-container-column;
    & #top {
      width: 100%;
        @include header-format
    }
    & #bottom {
        @include template-format;
        & #template {
          @include flex-container-column;
        }
    }
  }
}
</style>
