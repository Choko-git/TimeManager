<template>
  <div
    id="sidemenu"
    v-bind:class="{ mainSidemenuPushed: managementOpen }"
    class="noselect"
  > 
    <Logo />
    <div id="navigation">
      <div id="main-nav">
        <nav v-for="category in navRoutes" v-bind:key="category.name">
          <h1>
            {{ category.name }}
          </h1>
          <router-link
            v-for="link in category.links"
            v-bind:key="link.route"
            class="main-nav-link nav-link"
            tag="li"
            :to="link.route"
            v-bind:style="{
              backgroundImage: `url(${require(`../../assets/icons/${link.icon}.svg`)})`,
            }"
            >{{ link.title }}</router-link
          >
        </nav>
      </div>
      <div v-bind:class="{ navActive: managementOpen }" id="manage-nav">
        <h1>Management</h1>
        <nav>
          <router-link
            v-for="link in managementNavRoutes"
            v-bind:key="link.route"
            class="management-nav-link nav-link"
            tag="li"
            :to="link.route"
            >{{ link.title }}</router-link
          >
        </nav>
      </div>
    </div>
  </div>
</template>

<script>
import { navRoutes, managementNavRoutes } from "./nav-elements";
import Logo from '@/components/Logo';

export default {
  data: function () {
    return {
      navRoutes: navRoutes,
      managementNavRoutes: managementNavRoutes,
      managementOpen: false,
    };
  },
  created: function () {
    this.setManagementOpen(this.$route.fullPath);
  },
  components : { Logo },
  watch: {
    $route(to) {
      console.log(to);
      this.setManagementOpen(to.fullPath);
      if (to.path === '/log-in') {
        this.managementNavRoutes = managementNavRoutes;
        this.navRoutes = navRoutes;
      }
    },
  },
  methods: {
    setManagementOpen: function (path) {
      this.managementOpen = path.includes("management");
    },
  },
};
</script>

<style lang="scss">
#sidemenu {
  position: relative;
  padding-top: 35px;
  & #navigation {
    margin-top: 20px;
    padding: 0;
    @include flex-container-column;
    & .nav-link {
      cursor: pointer;
      width: 100%;
      margin: 10px 0 20px 0;
      padding: 10px 10px 10px 50px;
      border-radius: 3px;
      font-size: 17px;
      color: white;
      text-shadow: $text-shadow;
      transition: background-color 0.15s ease, width $sidemenu-transition;
    }
    & #main-nav {
      & nav {
        border-top: $sidemenu-border;
        padding-top: 20px;
        padding-left: 40px;
        list-style: none;
        transition: padding-left $sidemenu-transition;
        & h1 {
          height: 30px;
          font-size: 22px;
          color: $sidemenu-title-color;
          opacity: 1;
          transition: opacity $sidemenu-transition;
        }
        & .main-nav-link {
          @include bgi-left-sidemenu;
          &:hover {
            background-color: $main-color-5-opacity-25;
            text-decoration: none;
          }
          &.router-link-active {
            box-shadow: $main-box-shadow;
            background-color: $main-color-4-opacity-25;
          }
        }
      }
    }

    #manage-nav {
      padding-top: 20px;
      transition: width $sidemenu-transition;
      position: absolute;
      background-color: $main-color-6;
      height: 100vh;
      width: 0;
      top: 0;
      right: 0;
      display: flex;
      flex-direction: column;
      & * {
        opacity: 0;
        transition: opacity $sidemenu-transition;
      }
      &.navActive {
        width: 220px;
        * {
          opacity: 1;
        }
      }
      & h1 {
        font-size: 23px;
        color: #201e1e;
        font-weight: bold;
        padding: 10px;
        border-left: 8px solid #15161b81;
        background-color: #cab38d6b;
        box-shadow: 4px 5px 10px 7 px #474e6181;
        width: 210px;
        margin-left: 10px;
      }
      & nav {
        padding-top: 105px;
        list-style: none;
        & .management-nav-link {
          margin-bottom: 18px;
          &:hover {
            background-color: $main-color-5-opacity-25;
            text-decoration: none;
          }
          &.router-link-active {
            box-shadow: $main-box-shadow;
            background-color: $main-color-4-opacity-25;
          }
        }
      }
    }
  }
  &.mainSidemenuPushed {
    & #logo{
      opacity: 0;
    }
    & #navigation {
      & #main-nav {
        & nav {
          padding-left: 10px !important;
          & h1 {
            opacity: 0;
          }
          & .main-nav-link {
            width: 40px;
            color: $main-color-1-opacity-0;
          }
        }
      }
    }
  }
}
</style>