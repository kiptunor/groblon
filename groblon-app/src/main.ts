/**
 * main.ts
 *
 * Bootstraps Vuetify and other plugins then mounts the App`
 */
 
import { createPinia } from 'pinia'

// Plugins
import { registerPlugins } from '@/plugins'

// Components
import App from './App.vue'

// Composables
import { createApp } from 'vue'

// Styles
import 'unfonts.css'

const app = createApp(App)
const pinia = createPinia()

registerPlugins(app)

app.use(pinia)
app.mount('#app')
