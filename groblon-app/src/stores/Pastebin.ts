import { defineStore } from 'pinia'
import { server } from '../api/server'


export const monacoControl = defineStore('monacoCtrl', {
  state: () => ({
    code: ''
  }),
  actions: {
    pushText(n: string) {
      this.code = n
    },
    setEmptyContent() {
      this.code = ''
    }
  }
})