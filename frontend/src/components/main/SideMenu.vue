<template>
  <div id="sidemenu">
    <div id="logo">
      <img src="../../assets/logo.svg" alt="homepage" />
    </div>
    <div id="navigation">
      <div id="main-nav">
        <nav v-for="category in navElement" v-bind:key="category.name">
          <h1>{{ category.name }}</h1>
          <router-link
            v-for="link in category.links"
            v-bind:key="link.route"
            class="main-nav-link"
            tag="li"
            :to="link.route"
            v-bind:style="{
              'background-image': `url(${require('../../assets/icons/' +
                link.icon +
                '.svg')})`,
            }"
            >{{ link.title }}</router-link
          >
        </nav>
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
      managementOpen: false
    };
  },
  created: function () {
    console.log(this.navElement);
  },
  watch: {
    $route(to, from) {
      console.log(to, from);
    },
  },
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
    & nav {
      border-top: $sidemenu-border;
      padding-top: 20px;
      padding-left: 40px;

      list-style: none;
      & h1 {
        font-size: 22px;
        color: $sidemenu-title-color;
      }
      & .main-nav-link {
        margin-top: 10px;
        margin-bottom: 20px;
        cursor: pointer;
        padding: 10px 10px 10px 50px;
        border-radius: 3px;
        font-size: 17px;
        color: white;
        text-shadow: $text-shadow;
        transition: background-color 0.2s ease;
        @include bgi-left;
        &:hover {
          background-color: $main-color-5-opacity-25;
          text-decoration: none;
        }
        &.router-link-active {
          box-shadow: $box-shadow;
          background-color: $main-color-4-opacity-25;
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