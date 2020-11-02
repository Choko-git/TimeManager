<template>
  <div class="autocomplete-field">
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
  props: ["placeholder", "noDataText", "field", "keyToShow", "dropDown"],
  methods: {
    focusOut: function () {
      setTimeout(() => {
        if (this.dropDownClicked) {
          this.dropDownClicked = false;
        } else {
          this.isFocus = true;
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
      console.log(2);
      this.dropDownClicked = true;
      this.$refs[this.placeholder].value = data[this.keyToShow];
      this.$emit("dataSelected", data);
      setTimeout(() => (this.isFocus = false), 100);
    },
    clickOnDropDown() {
      this.dropDownClicked = true;
    },
  },
};
</script>

<style lang="scss">
.autocomplete-field {
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
        border : none;
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