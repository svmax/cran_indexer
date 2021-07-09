/* eslint no-console:0 */
import Vue from 'vue';
import Vuex from 'vuex';
import Vuetify from 'vuetify';
import VueRouter from 'vue-router';

import 'assets/stylus/main.styl';
import layout from 'components/layout';
import routes from 'helpers/routes';
import storeSettings from 'store';

/*
 * Dependencies injection
*/
Vue.use(Vuex);
Vue.use(VueRouter);
Vue.use(Vuetify);

/*
 * Creation of store
*/
export const store = new Vuex.Store(storeSettings);

/*
 * Router setup:
*/
export const router = new VueRouter(routes(store));

/*
 * App initialization:
*/
document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('root');
  new Vue({
    store,
    router,
    ...layout,
  }).$mount('#root');
});
