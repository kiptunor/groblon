import { defineStore } from 'pinia'
import Handsontable from 'handsontable'
import Papa from 'papaparse'




export const useTableCtrl = defineStore('table', {
  state: () => ({
    hot: null as any
  }),
  actions: {
    setHotInstance(instance: Handsontable) {
      this.hotInstance = instance
    },
    getHotInstance(): Handsontable | null {
      return this.hotInstance
    },
    setEmptyTable() {
      if (!this.hotInstance) return
      const rows = 50
      const cols = 50
      const predefined_cells = Array.from({ length: rows }, () => Array.from({ length: cols }, () => ''))
      
      this.hotInstance.loadData(predefined_cells)
      
    },
    loadCsv(csv: string) {
      if (!this.hotInstance) return

      const result = Papa.parse(csv.trim(), {
        skipEmptyLines: true
      })
    
      const [headers, ...data] = result.data as string[][]
    
      this.hotInstance.updateSettings({
        colHeaders: headers
      })
    
      this.hotInstance.loadData(data)
    },
    // Optional: save CSV globally
    getCsvString() {
      if (!this.hotInstance) return ''
      return this.hotInstance.getPlugin('exportFile').exportAsString('csv', {
        bom: true,
        columnHeaders: true,
        rowHeaders: true
      })
    }
  }
})