import { defineStore } from 'pinia'
import { server } from '../api/server'

export const textEditorControl = defineStore('textEditorControl', {
  state: () => ({
    textarea_string: ''
  }),
  actions: {
    pushText(n: server.Note) {
      this.textarea_string = n.content
    },
    emptyContent() {
      this.textarea_string = ''
    }
  }
})