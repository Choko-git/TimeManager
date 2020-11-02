<template>
  <div v-if="totalPages > 1" id="pager-container">
    <button
      class="change-page-button page-block"
      id="page-left"
      @click="chosenPage(page - 1)"
    >
      ←
    </button>
    <div id="page-numbers">
      <button
        v-for="currentPage in pageArray()"
        v-bind:key="currentPage"
        @click="chosenPage(currentPage)"
        class="page-number page-block"
        v-bind:class="{ 'current-page': currentPage === page }"
      >
        {{ currentPage }}
      </button>
    </div>
    <button
      class="change-page-button page-block"
      id="page-right"
      @click="chosenPage(page + 1)"
    >
      →
    </button>
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      minPage: null
    };
  },
  props: ["totalPages", "page"],
  created: function() {
    this.refresh(this.page);
  },
  watch: {
    page: function(page) {
      this.refresh(page);
    }
  },
  methods: {
    pageArray() {
      const nbPages = this.totalPages > 9 ? 9 : this.totalPages;
      return Array.from(Array(nbPages), (_, i) => i + this.minPage);
    },
    chosenPage(page) {
      if (page !== this.page && page > 0 && page <= this.totalPages) {
        this.$emit("changePage", page);
      }
    },
    refresh(page) {
      if (this.totalPages > 9 && page > 6) {
        if (page + 1 < this.totalPages) {
          this.minPage = page - 6;
        } else {
          this.minPage = this.totalPages - 8;
        }
      } else {
        this.minPage = 1;
      }
    }
  }
};
</script>

<style lang="scss">
#pager-container {
  margin: 40px auto;
  height: 30px;
  display: flex;
  float: right;
  & .page-block {
    cursor: pointer;
    height: 30px;
    width: 30px;
    border-radius: 5px;
    background-color: $main-color-1;
  }
  & .change-page-button {
    border: none;
    color: white;
    background-size: 14px 9px;
  }
  & #page-numbers {
    margin: 0 30px;
    & .page-number {
      border: none;
      font-size: 14px;
      font-weight: 600;
      color: white;
      &:not(:last-child) {
        margin-right: 10px;
      }
    }
  }
  & .current-page {
    background-color: $main-color-2;
    color: white;
  }
}
</style>