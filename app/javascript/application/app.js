import Vue from 'vue';
import Root from './components/root.vue';

import Buefy from 'buefy';
import 'buefy/dist/buefy.css';

Vue.use(Buefy);

global.$(document).ready(function () {
  new Vue({
    render: h => h(Root),
  }).$mount('#walrus-ai-web-crawler');
});
