import './bootstrap';
import { createApp } from 'vue';
import UserSpreadsheet from './components/UserSpreadsheet.vue';

const app = createApp({});
app.component('user-spreadsheet', UserSpreadsheet);
app.mount('#app');
