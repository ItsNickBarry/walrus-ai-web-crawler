import Vue from 'vue';
import Root from './components/root.vue';

global.$(document).ready(function () {
  new Vue({
    render: h => h(Root),
  }).$mount('#rails-vue-template');
});
