<template>
  <v-toolbar color="primary-light">
    <v-div class="mr-4"></v-div>
    <v-btn
      class="mr-3"
      icon="mdi-dots-vertical"
      size="small"
      variant="elevated"
    >
      <v-icon></v-icon>
      <v-speed-dial activator="parent" :location="dialLocation" open-on-hover>
        <v-btn
          v-for="(item, i) in dialActionsReversed"
          :key="i"
          v-tooltip="{ location: tooltipLocation, text: item.tooltip, color: 'primary' }"
          :color="item.color"
          :icon="item.icon"
          @click="onDialAction(item, i)"
        ></v-btn>
      </v-speed-dial>
    </v-btn>
    
    <v-btn
      color="grey-500"
      variant="elevated"
      v-tooltip:bottom="'Note properties'"
      class="ml-3"
      icon="mdi-information-slab-box"
    ></v-btn>
  </v-toolbar>

  <!-- Table Area -->
  <div id="example1" class="table-container">
    <hot-table ref="hotTableComponent" :settings="hotSettings"></hot-table>
  </div>
  
  <!-- Create Table dialog -->
  <div class="pa-4 text-center">
    <v-dialog
      v-model="tableDialog"
      max-width="600"
    >
      <v-card
        prepend-icon="mdi-text-box"
        title="Create new table"
      >
        <v-card-text>
          <v-text-field
            v-model="tableName"
            label="Name"
            required
            :rules="noteNameRule"
            variant="solo-filled"
          ></v-text-field>
        </v-card-text>

        <v-divider></v-divider>

        <v-card-actions>
          <v-spacer></v-spacer>

          <v-btn
            text="Cancel"
            variant="plain"
            @click="tableDialog = false"
          ></v-btn>

          <v-btn
            color="primary"
            :disabled="!tableName"
            text="Create"
            variant="tonal"
            @click="createTable()"
          ></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import { HotTable } from '@handsontable/vue3';
//import { registerAllModules } from 'handsontable/registry';
import 'handsontable/styles/handsontable.css';
import 'handsontable/styles/ht-theme-horizon.css';

import { useUI } from '@/stores/ui';
import { useTableCtrl } from '@/stores/TableEditor';
import { useTablesStore } from '@/stores/ui'
import { server } from '../api/server'




const ui = useUI()
const tablesStore = useTablesStore()



const current_file_path = ref<string | null>(null)


watch(
  () => ui.selected,
  (newVal) => {
    if (!newVal || newVal.length === 0) {
      return
    }
    current_file_path.value = newVal[0]
    // console.log('Current file path:', current_file_path.value)
  },
  { immediate: true }
)



const rows = 50
const cols = 50
const predefined_cells = Array.from({ length: rows }, () => Array.from({ length: cols }, () => ''))

let saveRefreshTimeout: number | undefined;

const COLUMN_TYPES = {
  text: 'Text',
  numeric: 'Numeric',
  checkbox: 'Checkbox',
  date: 'Date',
  time: 'Time',
  dropdown: 'Dropdown',
  autocomplete: 'Autocomplete',
  readOnly: 'Read only'
}


const TableEditorComponent = defineComponent({
  data() {
    return {
      hotSettings: {
        themeName: 'ht-theme-horizon-dark',
        
        data: predefined_cells,

        colHeaders: true,
        rowHeaders: true,
        contextMenu: true,
        filters: true,
 
        dropdownMenu: {
          items: {
            rename_column: {
              name: 'Rename column',
              callback(_, selection) {
                const col = selection[0].start.col
                const headers = [...this.getColHeader()]
                const newName = prompt('New column name', headers[col])
                if (!newName) return
        
                headers[col] = newName
                this.updateSettings({ colHeaders: headers })
              }
            },
           
            separator1: '---------',
            insert_col_left: {
              name: 'Insert column left',
              callback(_, selection) {
                const col = selection[0].start.col
                this.alter('insert_col_start', col)
        
                const headers = [...this.getColHeader()]
                headers.splice(col, 0, 'New column')
                this.updateSettings({ colHeaders: headers })
              }
            },
               
            insert_col_right: {
              name: 'Insert column right',
              callback(_, selection) {
                const col = selection[0].start.col + 1
                this.alter('insert_col_start', col)
        
                const headers = [...this.getColHeader()]
                headers.splice(col, 0, 'New column')
                this.updateSettings({ colHeaders: headers })
              }
            },
            remove_col: 'remove_col',
            // ----------------
            // Clear column
            // ----------------
            clear_column: {
              name: 'Clear column',
              callback(_, selection) {
                const col = selection[0].start.col
                const rows = this.countRows()
        
                for (let r = 0; r < rows; r++) {
                  this.setDataAtCell(r, col, null)
                }
              }
            },
            
            separator4: '---------',
            
            // ----------------
            // Alignment
            // ----------------
            align_left: {
              name: 'Align left',
              callback(_, selection) {
                const col = selection[0].start.col
                this.setCellMeta(0, col, 'className', 'htLeft')
                this.render()
              }
            },
            
            align_center: {
              name: 'Align center',
              callback(_, selection) {
                const col = selection[0].start.col
                this.setCellMeta(0, col, 'className', 'htCenter')
                this.render()
              }
            },
            
            align_right: {
              name: 'Align right',
              callback(_, selection) {
                const col = selection[0].start.col
                this.setCellMeta(0, col, 'className', 'htRight')
                this.render()
              }
            },
            
            separator5: '---------',
            
            // ----------------
            // Read-only toggle
            // ----------------
            toggle_readonly: {
              name: 'Toggle read-only',
              callback(_, selection) {
                const col = selection[0].start.col
                const meta = this.getCellMeta(0, col)
        
                const newState = !meta.readOnly
                this.setCellMeta(0, col, 'readOnly', newState)
                this.render()
              }
            },
            separator2: '---------',
           
            // ----------------
            // Filtering (built-in)
            // ----------------
            filter_by_condition: 'filter_by_condition',
            filter_by_value: 'filter_by_value',
            filter_action_bar: 'filter_action_bar',
        
            separator3: '---------',
          }
        },
        
        afterChange: (changes, source) => {
          if (!changes || source !== 'edit') return;
          
          // Access the Handsontable instance via Vue ref
          const hot = this.$refs.hotTableComponent.hotInstance
          if (!hot) return;
          
          const exportPlugin = hot.getPlugin('exportFile');
          
          changes.forEach(([row, col, oldValue, newValue]) => {
            if (oldValue !== newValue) {
              const csvString = exportPlugin.exportAsString('csv', {
                bom: true,
                columnHeaders: true,
                columnDelimiter: ',',
                exportHiddenColumns: true,
                exportHiddenRows: true,
                rowDelimiter: '\r\n',
                rowHeaders: false,
              });

              server.save_table({
                filename: current_file_path.value,
                content: csvString
              })
              
              // Reload table list and their contents with a bit of delay due to communication latency
              clearTimeout(saveRefreshTimeout);
              saveRefreshTimeout = window.setTimeout(async () => {
                await tablesStore.fetchTables()
              }, 500);
            }
          });
        },
 
        width: '100%',
        height: 880,
        //fixedColumnsStart: 1,
        manualColumnMove: true,
        autoWrapRow: true,
        autoWrapCol: true,
        licenseKey: 'non-commercial-and-evaluation'
      }
    }
  },
  methods: {
    swapHotData() {
      /*
      Todo:
      Load table from CSV received string or load a set of 50 x 50 table if no received CSV content is available.
      */
      // The Handsontable instance is stored under the `hotInstance` property of the wrapper component.
      this.$refs.hotTableComponent.hotInstance.loadData([['new', 'data']]);
    },
    getCsvString() {
      const hot = this.$refs.hotTableComponent.hotInstance;
    
      // Use the exportFile plugin
      const exportPlugin = hot.getPlugin('exportFile');
    
      const exportedString = exportPlugin.exportAsString('csv', {
        bom: true,
        columnDelimiter: ',',
        columnHeaders: true,
        exportHiddenColumns: true,
        exportHiddenRows: true,
        rowDelimiter: '\r\n',
        rowHeaders: false,
      });
    
      console.log('CSV String:', exportedString);
      return exportedString;
    }
  },
  mounted() {
    const store = useTableCtrl()
    store.setHotInstance(this.$refs.hotTableComponent.hotInstance)
  },
  components: { HotTable }
});

export default TableEditorComponent;
</script>

<script setup lang="ts">
import { computed, ref, shallowRef, watch } from 'vue'
import { server } from '../api/server'
import { useTablesStore } from '@/stores/ui'




const tablesStore = useTablesStore()
const tableCtrl = useTableCtrl()

const tableDialog = shallowRef(false)
const tableName = ref('')



const dialActions = [
  { color: 'info-darken-1', icon: 'mdi-table-plus', tooltip: 'Add Table' },
  { color: 'red', icon: 'mdi-table-minus', tooltip: 'Remove Selected Table' },
  { color: 'primary', icon: 'mdi-refresh', tooltip: 'Refresh Table list' },
]

const dialActionsReversed = [...dialActions].reverse()

function onDialAction(item, index) {
  if (item.icon === 'mdi-table-plus') {
    tableName.value = ''
    tableDialog.value = true
  }
  if (item.icon === 'mdi-table-minus') {
    // Todo: Add warning dialog
    tableCtrl.setEmptyTable()
    server.delete_file(current_file_path.value)
    tablesStore.fetchTables()
  }
  if (item.icon === 'mdi-refresh') {
    tablesStore.fetchTables()
  }
}

function createTable() {
  tableDialog.value = false
  server.create_table(tableName.value)
  
  tablesStore.fetchTables()
}

</script>