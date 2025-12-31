import { defineStore } from 'pinia'
import { ref } from 'vue'
import { server } from '../api/server'

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
      if (!this.opened.includes(name))
        this.opened.push(name)
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



export const useNotesStore = defineStore('notes', () => {
  // reactive array for notes
  const notes = ref<Note[]>([])
  const loading = ref(false)

  // fetch notes from server
  async function fetchNotes() {
    loading.value = true
    try {
      const res = await server.get_notes()
      // assuming res.data is the array of notes
      notes.value = res.notes
    } catch (err) {
      console.error('Failed to fetch notes:', err)
    } finally {
      loading.value = false
    }
  }

  return {
    notes,
    loading,
    fetchNotes,
  }
})

export const useTablesStore = defineStore('tables', () => {
  // reactive array for notes
  const tables = ref<Table[]>([])
  const loading = ref(false)

  // fetch notes from server
  async function fetchTables() {
    loading.value = true
    try {
      const res = await server.get_tables()
      // assuming res.data is the array of notes
      tables.value = res.table_data
    } catch (err) {
      console.error('Failed to fetch notes:', err)
    } finally {
      loading.value = false
    }
  }

  return {
    tables,
    loading,
    fetchTables,
  }
})