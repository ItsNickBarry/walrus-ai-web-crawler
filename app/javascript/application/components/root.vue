<template>
  <div id="app">
    <header class="header hero-head">
      <div class="hero-body">
        <div class="container">
          <h1 class="title">
            walrus.ai Web Crawler
          </h1>
        </div>
      </div>
    </header>

    <div class="container">
      <b-message
        v-for="e in errors"
        :key="e"
        title="Error"
        class="is-warning"
      >
        {{ e }}
      </b-message>

      <form id="form" action="javascript:void(0)" @submit="search">
        <b-field label="URI">
          <b-autocomplete
            v-model="uri"
            name="web_page[uri]"
            :data="suggestions"
            @select="option => select = option"
          >
            <template slot="empty">
              No matches
            </template>
          </b-autocomplete>
        </b-field>

        <b-field grouped>
          <b-field label="Search Depth" expanded>
            <b-numberinput name="depth" min="1" />
          </b-field>

          <b-field label="Cache Expiry (seconds ago)" expanded>
            <b-numberinput name="cache" min="1" />
          </b-field>

          <!-- eslint-disable-next-line no-irregular-whitespace -->
          <b-field label=" ">
            <b-button native-type="submit" :disabled="loading">
              Search
            </b-button>
          </b-field>
        </b-field>
      </form>

      <div class="results">
        <DefaultLoader v-show="loading" :size="475" />

        <div v-show="!loading">
          <div v-for="el in collection" :key="el.id">
            <a :href="el.uri">{{ el.title }}</a>
          </div>
        </div>

        <b-pagination
          v-show="collection.length"
          :total="hits"
          :current.sync="page"
          :per-page="20"
        >
          <b-pagination-button
            :id="`page${props.page.number}`"
            slot-scope="props"
            :page="props.page"
            :disabled="loading"
          >
            {{ props.page.number }}
          </b-pagination-button>

          <b-pagination-button
            slot="previous"
            slot-scope="props"
            :page="props.page"
            :disabled="loading"
          >
            Previous
          </b-pagination-button>

          <b-pagination-button
            slot="next"
            slot-scope="props"
            :page="props.page"
            :disabled="loading"
          >
            Next
          </b-pagination-button>
        </b-pagination>
      </div>
    </div>
  </div>
</template>

<script>
import { DefaultLoader } from 'vue-spinners-css';

export default {
  components: { DefaultLoader },

  data: function () {
    return {
      loading: false,
      collection: [],
      hits: 0,
      page: 1,
      errors: [],
      uri: '',
      suggestions: [],
      suggestionNonce: 0,
    };
  },

  watch: {
    page: function () {
      this.search();
    },

    uri: function () {
      this.suggest();
    },
  },

  methods: {
    search: function () {
      this.loading = true;
      this.errors = [];

      let data = global.$('#form').serializeJSON();
      data.page = this.page - 1;

      global.$.ajax({
        type: 'GET',
        url: '/api/web_pages',
        data,
        success: function (res) {
          this.loading = false;
          this.collection = res.results;
          this.hits = res.hits;
          global.hhhhh = this.hits;
        }.bind(this),
        error: function (res) {
          this.loading = false;
          this.errors = res.responseJSON;
        }.bind(this),
      });
    },

    suggest: function () {
      let suggestionNonce = ++this.suggestionNonce;

      let data = { uri: global.$('#form').serializeJSON().web_page.uri };

      global.$.ajax({
        type: 'GET',
        url: '/api/uniform_resource_identifiers',
        data,
        success: function (res) {
          if (this.suggestionNonce == suggestionNonce) {
            this.suggestions = res.results;
          }
        }.bind(this),
      });
    },
  },
};
</script>

<style scoped>
</style>
