import { defineStore } from 'pinia'

// Better handling of the Media Access and Settings list items
export const useUI = defineStore('ui', {
  state: () => ({
    selected: [] as string[], // list-item selection
    opened: [] as string[], // list-group opened
  }),
  actions: {
    clearSelection() {
      this.selected = []
    },
    openGroup(name: string) {
      if (!this.opened.includes(name)) this.opened.push(name)
    },
    closeGroup(name: string) {
      this.opened = this.opened.filter(n => n !== name)
    },
    deselectItem(item: string) {
      if (this.selected.length <= 1) return
      this.selected = this.selected.filter(v => v !== item)
    },
  },
})