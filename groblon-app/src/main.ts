/**
 * main.ts
 *
 * Bootstraps Vuetify and other plugins then mounts the App`
 */

import { createPinia } from 'pinia'

// Composables
import { createApp } from 'vue'

// Plugins
import { registerPlugins } from '@/plugins'

import * as monaco from 'monaco-editor'


// Components
import App from './App.vue'

// Styles
import 'unfonts.css'

//addBasicEditor("prism-editor")

const app = createApp(App)
const pinia = createPinia()

registerPlugins(app)

app.use(pinia)

self.MonacoEnvironment = {
  getWorker(_, label) {
    if (label === 'json') {
          return new Worker(
            new URL(
              'monaco-editor/esm/vs/language/json/json.worker.js',
              import.meta.url
            ),
            { type: 'module' }
          )
        }
    
        if (label === 'css' || label === 'scss' || label === 'less') {
          return new Worker(
            new URL(
              'monaco-editor/esm/vs/language/css/css.worker.js',
              import.meta.url
            ),
            { type: 'module' }
          )
        }
    
        if (label === 'html' || label === 'handlebars' || label === 'razor') {
          return new Worker(
            new URL(
              'monaco-editor/esm/vs/language/html/html.worker.js',
              import.meta.url
            ),
            { type: 'module' }
          )
        }
    
        if (label === 'typescript' || label === 'javascript') {
          return new Worker(
            new URL(
              'monaco-editor/esm/vs/language/typescript/ts.worker.js',
              import.meta.url
            ),
            { type: 'module' }
          )
        }
    
        return new Worker(
          new URL(
            'monaco-editor/esm/vs/editor/editor.worker.js',
            import.meta.url
          ),
          { type: 'module' }
        )
  }
}
app.mount('#app')