<template>
  <div class="autocomplete-field">
    <input
      v-bind:class="{
        placeHolderFormat: selectedData && selectedData !== 'all',
      }"
      type="text"
      autocomplete="off"
      @keyup="searchData($event.target.value)"
      @keypress="onKeyPressed"
      @focus="isFocus = true"
      @blur="isFocus = true"
      :placeholder="placeholder"
    />
    <div v-if="isFocus && dropDown" class="contain-dropdown-list">
      <ul class="dropdown-list">
        <div v-if="queryOk">
          <div v-if="dataToSelect && dataToSelect.length > 0">
            <li class="li-head">Select a user</li>
            <li
              v-for="data of dataToSelect"
              v-bind:key="data.username"
              @click="onSelectData(data)"
              class="li-link"
            >
              <div>{{ data[keyToShow] }}</div>
            </li>
          </div>
          <li v-else-if="dataToSelect && !dataToSelect.length">
            No user found
          </li>
        </div>
        <div v-else>
          <li class="loader"></li>
        </div>
      </ul>
    </div>
  </div>
</template>


<script>
export default {
  data: function () {
    return {
      selectedData: null,
      focusOnInput: null,
      typingTimer: null,
      keyPressed: null,
      isFocus: false,
    };
  },
  props: [
    "placeholder",
    "noDataText",
    "dataToSelect",
    "keyToShow",
    "queryOk",
    "dropDown",
  ],
  methods: {
    searchData: function (value) {
      this.keyPressed = false;
      clearTimeout(this.typingTimer);
      this.typingTimer = setTimeout(() => {
        if (!this.keyPressed) {
          value = value.toLowerCase().trim();
          this.$emit("searchData", value);
        }
      }, 0);
    },

    enterInput: function () {
      this.searchData("");
      setTimeout(() => {
        this.focusOnInput = true;
      }, 200);
    },

    onKeyPressed() {
      this.keyPressed = true;
    },

    exitInput(select) {
      setTimeout(() => {
        select.value = "";
        this.focusOnInput = false;
      }, 200);
    },

    onSelectData(data) {
      this.$emit("dataSelected", data);
    },
  },
};
</script>

<style lang="scss">
.autocomplete-field {
  & input {
    @include classic-input;
    &.placeHolderFormat {
      &.uppercase::placeholder {
        text-transform: uppercase;
      }
    }
  }
  & ul {
    & .uppercase {
      text-transform: uppercase;
    }
  }
  & .contain-dropdown-list {
    position: relative;
    .dropdown-list {
      box-shadow: 0px 0 10px 0 rgba(92, 92, 92, 0.2);
      background-color: rgb(248, 248, 248);
      top: 0px;
      list-style: none;
      margin: 0;
      z-index: 2;
      width: 100%;
      border-radius: 5px;
      position: absolute;
      padding: 0;
      & .li-head {
        text-decoration: underline;
        padding-bottom: 2px;
        font-weight: bold;
      }
      & li {
        transition: all 0.2s;
        cursor: pointer;
        font-size: 15px;
        color: rgb(82, 82, 82);
        line-height: 1.67;
        padding: 5px 10px;
        padding-left: 20px;
        display: flex;
      }
      & .li-link:hover {
        color: rgb(85, 85, 85);
        font-weight: 800;
        opacity: 0.8;
      }
      & .loader {
        display: flex;
        width: 20px;
        height: 20px;
        margin-top: 5px;
        margin: auto;
        padding: 10px 0 !important;
        margin-bottom: 20px;
        &:after {
          content: "";
          display: block;
          width: 20px;
          height: 20px;
          border-radius: 50%;
          border: 2px solid #32292f;
          border-color: #32292f transparent #32292f transparent;
          animation: lds-dual-ring 1.2s linear infinite;
        }
      }
    }
  }
}
</style>