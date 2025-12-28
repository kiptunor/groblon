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

  
  <!--<div id="example1" class="table-container">
    <hot-table :settings="hotSettings"></hot-table>
  </div>-->
  <div id="example1" class="table-container">
    <div class="example-controls-container">
      <div class="controls">
        <v-btn variant="tonal" v-on:click="swapHotData">Load new data</v-btn>
      </div>
    </div>
  
    
    <hot-table ref="hotTableComponent" :settings="hotSettings"></hot-table><br/>
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
import { registerAllModules } from 'handsontable/registry';
import 'handsontable/styles/handsontable.css';
import 'handsontable/styles/ht-theme-horizon.css';


registerAllModules();



const rows = 50
const cols = 50
const predefined_cells = Array.from({ length: rows }, () => Array.from({ length: cols }, () => ''))


const TableEditorComponent = defineComponent({
  data() {
    return {
      hotSettings: {
        themeName: 'ht-theme-horizon-dark',
 
        // data: [
        //   ['A1', 'B1', 'C1', '67'],
        //   ['A2', 'B2', 'C2', '67'],
        //   ['A3', 'B3', 'C3', '67'],
        // ],
        
        data: predefined_cells,

        colHeaders: true,
        rowHeaders: true,
        
        contextMenu: true,

 
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
            remove_col: 'remove_col'
           }
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
      // The Handsontable instance is stored under the `hotInstance` property of the wrapper component.
      this.$refs.hotTableComponent.hotInstance.loadData([['new', 'data']]);
    }
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

const tableDialog = shallowRef(false)
const tableName = ref('')



const dialActions = [
  { color: 'info-darken-1', icon: 'mdi-table-plus', tooltip: 'Add Table' },
  { color: 'red', icon: 'mdi-table-minus', tooltip: 'Remove Selected Table' },
  { color: 'primary', icon: 'mdi-refresh', tooltip: 'Refresh Table list' },
]

// Tried to fix that issue somehow XDDDD
const dialActionsReversed = [...dialActions].reverse()

function onDialAction(item, index) {
  if (item.icon === 'mdi-table-plus') {
    tableName.value = ''
    tableDialog.value = true
    // server.create_table(current_file_path.value)
    console.log('Create table')
    //createTable();
  }
  if (item.icon === 'mdi-table-minus') {
    // Todo: Add warning dialog
    server.delete_table(current_file_path.value)
    tablesStore.fetchTables()
    console.log('Delete table')
  }
  if (item.icon === 'mdi-refresh') {
    tablesStore.fetchTables()
    // console.log('Refresh note list action')
    console.log('Refresh table list')
  }
}

function createTable() {
  // server.create_table(current_file_path.value)
  tableDialog.value = false
  server.create_table(tableName.value)
  
  // tablesStore.fetchTables()
}

</script>