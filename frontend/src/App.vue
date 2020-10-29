<template>
  <div id="content">
    <div id="left">
      <SideMenu />
    </div>
    <div id="right">
      <Header />
      <Template />
    </div>
  </div>
</template>


<script>
import Header from "./components/main/Header";
import SideMenu from "./components/main/SideMenu";
import Template from "./components/main/Template";
export default {
  components : {
    Header,
    SideMenu,
    Template
  }
};
</script>

<style lang="scss">
  #content {
    display: flex;
    height: 100vh;
    width: 100vw;
    & #left {
      width: 20%;
    }
    & #right {
      width: 80%;
    }
  }
</style>
