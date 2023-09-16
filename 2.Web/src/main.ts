import { createApp } from 'vue';
import { createPinia } from 'pinia';

// 分辨率兼容
import 'amfe-flexible';

import 'animate.css';
import 'animate.css/animate.compat.css';

import App from './App.vue';
import router from './router';

import './assets/styles/main.scss';

const app = createApp(App);

const pinia = createPinia();
app.use(pinia);
app.use(router);

// app.use(vue3videoPlay);

app.mount('#app');
