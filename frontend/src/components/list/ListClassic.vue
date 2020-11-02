<template>
  <div class="list-classic">
    <div class="list-classic-table">
      <div v-if="noData" class="no-data-block">
        <h2>{{ noDataText }}</h2>
      </div>
      <div v-else-if="dataToShow && !dataToShow.length" class="no-data-block">
        <h2>{{ noResultText }}</h2>
      </div>
      <table v-else>
        <thead>
          <tr>
            <th
              scope="col"
              v-for="column of columns"
              :key="column.name"
              :style="{ width: column.width }"
            >
              {{ column.name }}
              <span
                v-if="column.sortIndex"
                :class="{ sortActive: column.sortActive }"
                @click="sort(column)"
                >▼</span
              >
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            :key="element.name"
            v-for="element of dataToShow"
            class="table-row"
          >
            <td
              v-for="column of element"
              :key="column.value"
              :class="column.class"
            >
              {{ column.value }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <Pager
      :totalPages="totalPages"
      :page="page"
      @changePage="changePage($event)"
    />
  </div>
</template>

<script>
import Pager from "./Pager";

export default {
  data: () => ({
    totalPages: null,
    totalPerPage: 10,
    page: 1,
    dataToShow: null,
    noData: true,
  }),
  props: ["data", "columns", "noDataText", "noResultText"],
  created: function () {
    if (this.data) {
      this.noData = false;
      this.setDataToShow();
    } 
  },
  components: {
    Pager,
  },
  watch: {
    data: function () {
      this.setDataToShow();
    },
  },
  methods: {
    setDataToShow() {
      this.dataToShow = [];
      let current = (this.page - 1) * this.totalPerPage;
      let max = this.page * this.totalPerPage;
      for (let i = current; i < max; i++) {
        if (this.data[i]) {
          this.dataToShow.push(this.data[i]);
        }
      }
      this.totalPages = Math.ceil(this.data.length / this.totalPerPage);
    },
    changePage(page) {
      this.page = page;
      this.setDataToShow();
    },
    sort(column) {
      this.columns.forEach((_) => (_.sortActive = false));
      column.sortActive = true;
      this.$emit("sort", column);
    },
  },
};
</script>

<style lang="scss">
.list-classic {
  @include flex-container-column;
  & .list-classic-table {
    height: 400px;
    display: flex;
    width: 100%;
    & .no-data-block {
      height: 100px;
      width: 100%;
      padding: 20px 50px;
      background-color: $main-color-3;
      display: flex;
      & h2 {
        margin: auto;
        font-size: 25px;
        font-style: italic;
        color: $main-color-1;
        font-weight: normal;
      }
    }
    & table {
      width: 100%;
      table-layout: fixed;
      border-collapse: collapse;
      * {
        border: none;
      }
      & thead {
        height: 20px;
        & tr {
          background-repeat: no-repeat;
          background-position: right;
          height: 100%;
          & th {
            padding: 0 !important;
            font-size: 14px;
            color: $main-color-1;
            text-transform: uppercase;
            text-decoration: underline;
            & span {
              display: inline-block;
              transform: rotate(0deg);
              transition: all 0.25s;
              &.sortActive {
                transform: rotate(180deg);
              }
            }
          }
        }
      }
      & tbody {
        & tr {
          height: 45px;
          &:not(:last-child) {
            border-bottom: 1px solid rgba(0, 0, 0, 0.432);
          }
          & td {
            height: 20px;
            padding: 0 !important;
            background: white;
            width: 100%;
            &.status::before {
              content: "\00a0\00a0";
              margin: auto;
              padding: 0px 6px;
              border-radius: 50%;
            }
            &.status-present::before {
              background-color: rgb(86, 165, 49);
            }
            &.status-absent::before {
              background-color: red;
            }
          }
        }
      }
    }
  }
}
</style>