<template>
  <div id="sidemenu">
    <div id="logo">
      <img src="../../assets/logo.svg" alt="homepage" />
    </div>
    <div id="navigation">
      <div id="main-nav">
        <ul v-for="category in navElement" v-bind:key="category.name">
          <h1>{{ category.name }}</h1>
          <li
            v-for="link in category.links"
            v-bind:key="link.title"
            class="main-nav-link"
          >
            {{ link.title }}
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import navElement from "./nav-elements";

export default {
  data: function () {
    return {
      navElement: navElement,
    };
  },
  created: function () {},
};
</script>

<style lang="scss">
#sidemenu {
  z-index: 30;
  & #logo {
    display: flex;
    max-width: 100%;
    height: auto;
    margin-top: 50px;
    & img {
      margin: auto;
      width: 120px;
      height: auto;
    }
  }
}

#navigation {
  padding: 0;
  display: flex;
  flex-direction: column;
  & #main-nav {
    margin-top: 20px;
    & ul {
      border-top: $sidemenu-border;
      padding-top: 20px;
      padding-left: 40px;

      list-style: none;
      & h1 {
        font-size: 22px;
        color: #bacdb0;
      }
      & .main-nav-link {
        cursor: pointer;
        font-size: 17px;
        color: white;
        text-shadow: 1px 1px 3px rgba(172, 183, 213, 0.089);
        margin-top: 10px;
        margin-bottom: 10px;
        padding: 10px 20px 10px 50px;
        border-radius: 3px;
        transition: background-color 0.2s ease;
        &:hover {
          background-color: $main-color-5-opacity;
          text-decoration: none;
        }
        &.router-link-active {
          box-shadow: 0px 0 10px 0 rgba(102, 106, 114, 0.2);
          background-color: #5753669a;
        }
      }
    }
  }
}

.sidebar-link {
  &:hover {
    color: #b3bbd6;
  }
}
</style>