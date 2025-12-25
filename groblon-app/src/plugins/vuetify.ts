/**
 * plugins/vuetify.ts
 *
 * Framework documentation: https://vuetifyjs.com`
 */

// Styles
import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'

// Composables
import { type ThemeDefinition, createVuetify } from 'vuetify'




const staticPrimaryColor = '#007CD6'
const staticPrimaryDarkenColor = '#005999'

const groblon_dark: ThemeDefinition = {
  dark: true,
  colors: {
    'primary':                  staticPrimaryColor,
    'on-primary':               '#fff',
    'primary-darken-1':         staticPrimaryDarkenColor,
    'primary-light':            '#009999',
    'secondary':                '#8592A3',
    'on-secondary':             '#fff',
    'secondary-darken-1':       '#788393',
    'secondary-light':          '#9DA8B5',
    'success':                  '#71DD37',
    'on-success':               '#fff',
    'success-darken-1':         '#66C732',
    'success-light':            '#53D28C',
    'info':                     '#03C3EC',
    'on-info':                  '#fff',
    'info-darken-1':            '#03AFD4',
    'info-light':               '#35CFF0',
    'warning':                  '#FFAB00',
    'on-warning':               '#fff',
    'warning-darken-1':         '#E69A00',
    'warning-light':            '#FFBC33',
    'error':                    '#FF3E1D',
    'on-error':                 '#fff',
    'error-darken-1':           '#E6381A',
    'error-light':              '#FF654A',
    'background':               '#262626',
    'on-background':            '#E6E6F1',
    'surface':                  '#003333',
    'on-surface':               '#E6E6F1',
    'grey-50':                  '#1a1a1a',
    'grey-100':                 '#262626',
    'grey-200':                 '#333333',
    'grey-300':                 '#404040',
    'grey-400':                 '#4d4d4d',
    'grey-500':                 '#595959',
    'grey-600':                 '#666666',
    'grey-700':                 '#737373',
    'grey-800':                 '#808080',
    'grey-900':                 '8c8c8c',
    'grey-light':               '#a6a6a6',
    'perfect-scrollbar-thumb':  '#4A5072',
    'skin-bordered-background': '#2B2C40',
    'skin-bordered-surface':    '#2B2C40',
  },
  variables: {
    'code-color':                      '#d400ff',
    'overlay-scrim-background':        '#1D1D2A',
    'tooltip-background':              '#E6E6F1',
    'overlay-scrim-opacity':           0.6,
    'hover-opacity':                   0.06,
    'focus-opacity':                   0.1,
    'selected-opacity':                0.08,
    'activated-opacity':               0.16,
    'pressed-opacity':                 0.14,
    'dragged-opacity':                 0.1,
    'disabled-opacity':                0.4,
    'border-color':                    '#E6E6F1',
    'border-opacity':                  0.12,
    'table-header-color':              '#2B2C40',
    'high-emphasis-opacity':           0.9,
    'medium-emphasis-opacity':         0.7,
    'switch-opacity':                  0.4,
    'switch-disabled-track-opacity':   0.4,
    'switch-disabled-thumb-opacity':   0.8,
    'switch-checked-disabled-opacity': 0.3,
    'track-bg':                        '#41415F',
    'chat-bg':                         '#20202E',

    // Shadows
    'shadow-key-umbra-color': '#14141D',
    'shadow-xs-opacity': 0.18,
    'shadow-sm-opacity': 0.20,
    'shadow-md-opacity': 0.22,
    'shadow-lg-opacity': 0.24,
    'shadow-xl-opacity': 0.26,
  },
}

// https://vuetifyjs.com/en/introduction/why-vuetify/#feature-guides
export default createVuetify({
  theme: {
    defaultTheme: 'groblon_dark',
    themes: {
      groblon_dark
    }
  },
})