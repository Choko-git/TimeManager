<template>
  <div class="autocomplete-field">
    <div v-if="array" class="selected-list">
      <ul>
        <li
          v-for="element of field.listValue"
          :key="element[field.listKey]"
          @click="deleteData(element)"
        >
          {{ element[field.listKey] }} <span>✗</span>
        </li>
      </ul>
    </div>
    <input
      :ref="placeholder"
      v-bind:class="{
        placeHolderFormat: selectedData && selectedData !== 'all',
      }"
      type="text"
      autocomplete="off"
      @keyup="searchData($event.target.value)"
      @keypress="onKeyPressed"
      @focus="isFocus = true"
      @blur="focusOut"
      :placeholder="placeholder"
      :disabled="disabled"
    />
    <div
      v-if="isFocus && dropDown && inputTyped"
      class="contain-dropdown-list"
      @click="clickOnDropDown"
    >
      <ul class="dropdown-list">
        <div v-if="queryOk" class="data-list">
          <div
            v-if="field.dataToSelect && field.dataToSelect.length > 0"
            class="data-list"
          >
            <li
              v-for="data of field.dataToSelect"
              v-bind:key="data.username"
              @click="onSelectData(data)"
              class="li-link"
            >
              <label>{{ data[keyToShow] }}</label>
            </li>
          </div>
          <li
            v-else-if="field.dataToSelect && !field.dataToSelect.length"
            class="no-data"
          >
            {{ noDataText }}
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
      inputTyped: false,
      queryOk: true,
      dropDownClicked: false,
    };
  },
  props: [
    "placeholder",
    "noDataText",
    "field",
    "keyToShow",
    "dropDown",
    "array",
    "disabled"
  ],
  methods: {
    focusOut: function () {
      setTimeout(() => {
        if (this.dropDownClicked) {
          this.dropDownClicked = false;
        } else {
          this.isFocus = false;
        }
      }, 300);
    },
    searchData: function (value) {
      this.inputTyped = value.trim() !== "";
      this.queryOk = false;
      this.keyPressed = false;
      clearTimeout(this.typingTimer);
      this.typingTimer = setTimeout(() => {
        if (!this.keyPressed) {
          value = value.toLowerCase().trim();
          this.$emit("searchData", value);
          this.queryOk = true;
        }
      }, 350);
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
      this.dropDownClicked = true;
      if (this.field.array) {
        this.$refs[this.placeholder].value = null;
      } else {
        this.$refs[this.placeholder].value = data[this.keyToShow];
      }
      this.$emit("dataSelected", data);
      setTimeout(() => (this.isFocus = false), 100);
    },
    deleteData(data) {
      this.field.deleteMethod(data);
    },
    clickOnDropDown() {
      this.dropDownClicked = true;
    },
  },
};
</script>

<style lang="scss">
.autocomplete-field {
  & .selected-list {
    height: 60px;
    margin: 0;
    display: flex;
    & ul {
      display: flex;
      list-style: none;
      padding: 0;
      margin: 0;
      margin-bottom: 7px;
      overflow-x: auto;
      overflow-y: hidden;
      & li {
        position: relative;
        transition: all 0.4s;
        height: 40px;
        border-radius: 10px;
        margin: 0;
        margin-right: 10px;
        padding: 8px 30px 8px 12px;
        border: $grey-slight-border;
        box-shadow: $button-shadow;
        &:hover {
          font-weight: normal !important;
          border-color: $lighter-grey;
          color: $mid-grey;
          & span {
            color: red;
            opacity: 0.5;
          }
        }
        & span {
          color: black;
          position: absolute;
          top: 20%;
          right: 8%;
          margin: 0 !important;
          font-weight: 600;
          font-size: 14px;
        }
      }
      &::-webkit-scrollbar {
        position: absolute;
        width: auto;
        height: 7px;
      }

      &::-webkit-scrollbar-thumb {
        background-color: inherit;
        border-radius: 3px;
        border-radius: 10px;
        &:hover {
          background: rgba(114, 111, 111, 0.158);
        }
      }
    }
  }
  & input {
    @include classic-input;
    margin-top: 0 !important;
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
    margin: 0 !important;
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
      & .data-list {
        margin: 0;
      }
      & li {
        transition: all 0.2s;
        cursor: pointer;
        font-size: 15px;
        color: rgb(82, 82, 82);
        line-height: 1.67;
        padding-left: 20px;
        margin: 0;
        display: flex;
        & label {
          cursor: pointer;
          margin: 0;
        }
      }
      & .loader {
        border: none;
        display: flex;
        width: 20px;
        height: 20px;
        margin: auto;
        padding: 0px 0 !important;
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