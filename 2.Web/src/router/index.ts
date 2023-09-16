import { createRouter, createWebHistory } from 'vue-router';

import Home from '../views/Home.vue';
import MarketPlace from '../views/MarketPlace.vue';
import WorldView from '../views/WorldView.vue';
import MyCollection from '../views/MyCollection.vue';
import Setting from '../views/Setting.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home,
    },
    {
      path: '/market-place',
      name: 'marketPlace',
      component: MarketPlace,
    },
    {
      path: '/world-view',
      name: 'worldView',
      component: WorldView,
    },
    {
      path: '/my-collection',
      name: 'myCollection',
      component: MyCollection,
    },
    {
      path: '/setting',
      name: 'setting',
      component: Setting,
    },
  ],
});

export default router;
