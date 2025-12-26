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

  <div id="example1" class="table-container">
    <hot-table :settings="hotSettings"></hot-table>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import { HotTable } from '@handsontable/vue3';
import { registerAllModules } from 'handsontable/registry';
import 'handsontable/styles/handsontable.css';
import 'handsontable/styles/ht-theme-horizon.css';

// register Handsontable's modules
registerAllModules();

const ExampleComponent = defineComponent({
  data() {
    return {
      hotSettings: {
        themeName: 'ht-theme-horizon-dark',
 
        data: [
          ['A1', 'B1', 'C1', '67'],
          ['A2', 'B2', 'C2', '67'],
          ['A3', 'B3', 'C3', '67'],
        ],
 
        //colHeaders: ['First Name', 'Last Name', 'Email'],
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
        fixedColumnsStart: 1,
        manualColumnMove: true,
        autoWrapRow: true,
        autoWrapCol: true,
        licenseKey: 'non-commercial-and-evaluation'
      }
    }
  },
  components: { HotTable }
});

export default ExampleComponent;
</script>

<script setup lang="ts">
import { computed, ref, shallowRef, watch } from 'vue'
import { server } from '../api/server'



const dialActions = [
  { color: 'info-darken-1', icon: 'mdi-table-plus', tooltip: 'Add Table' },
  { color: 'red', icon: 'mdi-table-minus', tooltip: 'Remove Selected Table' },
  { color: 'primary', icon: 'mdi-table-refresh', tooltip: 'Refresh Table list' },
]

// Tried to fix that issue somehow XDDDD
const dialActionsReversed = [...dialActions].reverse()

function onDialAction(item, index) {
  if (item.icon === 'mdi-plus') {
    // noteName.value = ''
    // noteDialog.value = true
    console.log('Create table')
  }
  if (item.icon === 'mdi-trash-can') {
    // Todo: Add warning dialog
    // server.delete_table(current_file_path.value)
    // notesStore.fetchNotes()
    console.log('Delete table')
  }
  if (item.icon === 'mdi-refresh') {
    // notesStore.fetchNotes()
    // console.log('Refresh note list action')
    console.log('Refresh table list')
  }
}
</script>