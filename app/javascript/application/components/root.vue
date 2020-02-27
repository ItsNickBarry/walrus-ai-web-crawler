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

    <form action="javascript:void(0)" @submit="search">
      <b-field label="URI">
        <b-input name="web_page[uri]" />
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
      <DefaultLoader v-show="loading" :size="512" />
      <div v-for="el in collection" :key="el.id">
        <a :href="el.uri">{{ el.title }}</a>
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
    };
  },

  methods: {
    search: function () {
      this.loading = true;

      let data = global.$(event.target).closest('form').serializeJSON();

      global.$.ajax({
        type: 'GET',
        url: '/api/web_pages',
        data,
        success: function (res) {
          this.loading = false;
          this.collection = res;
        }.bind(this),
        error: function (res) {
          alert(res);
          this.loading = false;
          this.collection = res;
        }.bind(this),
      });
    },
  },
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
