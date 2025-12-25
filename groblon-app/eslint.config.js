import vuetify from 'eslint-config-vuetify'
import stylistic from '@stylistic/eslint-plugin'

//export default vuetify()
export default [
  ...vuetify(),
  {
    plugins: {
      '@stylistic': stylistic,
    },
    rules: stylistic.configs['disable-legacy'].rules,
  },
]
