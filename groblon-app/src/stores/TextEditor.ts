import { defineStore } from 'pinia'
import { server } from '../api/server'

export const textEditorControl = defineStore('textEditorControl', {
  state: () => ({
    textarea_string: ''
  }),
  actions: {
    pushText(n: server.Note) {
      // console.log('Pushing text:', n.text_content)
      this.textarea_string = n.text_content
    }
  }
})