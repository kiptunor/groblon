<template>
  <v-app>
    <v-layout>
      <v-container class="pa-0 ma-0" fluid>
        <v-row class="fill-height" no-gutters>
          <v-col cols="2">
            <v-sheet class="pa-2 ma-2 fill-height">
              <v-card class="pa-2" max-width="300">
                <v-list v-model:opened="ui.opened" v-model:selected="ui.selected" selectable density="proeminent">
                  <v-list-group color="primary" value="notes">
                    <template #activator="{ props }">
                      <v-list-item
                        class="mb-2"
                        color="primary"
                        v-bind="props"
                        prepend-icon="mdi-sticker-text"
                        rounded="lg"
                        title="Notes"
                      ></v-list-item>
                    </template>
  
                    <!-- Render the notes list-->
                    <v-list-item
                      v-for="item in notes_list"
                      :key="item.value"
                      class="mb-2"
                      :prepend-icon="item.icon"
                      rounded="lg"
                      :value="item.f_path_name"
                    >
                      <v-list-item-title>{{ item.f_path_name.split('/').pop() }}</v-list-item-title>
                    </v-list-item>
                  </v-list-group>
                  
                  <v-list-group color="primary" value="tables">
                    <template #activator="{ props }">
                      <v-list-item
                        class="mb-2"
                        color="primary"
                        v-bind="props"
                        prepend-icon="mdi-file-table"
                        rounded="lg"
                        title="Tables"
                      ></v-list-item>
                    </template>
  
                    <!-- Render table list-->
                    <v-list-item
                      v-for="item in table_list"
                      :key="item.value"
                      class="mb-2"
                      :prepend-icon="item.icon"
                      rounded="lg"
                      :value="item.f_path_name"
                    >
                      <v-list-item-title>{{ item.f_path_name.split('/').pop() }}</v-list-item-title>
                    </v-list-item>
                  </v-list-group>
  
                  <v-list-item
                    class="mb-2"
                    color="primary"
                    label="Media Access"
                    rounded="lg"
                    value="media-access"
                  >
                    <template #prepend>
                      <v-icon icon="mdi-multimedia" />
                    </template>
                    <v-list-item-title>Media Access</v-list-item-title>
                  </v-list-item>
  
                  <v-list-item
                    class="mb-2"
                    color="primary"
                    label="Settings"
                    rounded="lg"
                    value="settings"
                    @click="settingsDialog = true"
                  >
                    <template #prepend>
                      <v-icon icon="mdi-cog" />
                    </template>
                    <v-list-item-title>Settings</v-list-item-title>
                  </v-list-item>
                </v-list>
              </v-card>
            </v-sheet>
          </v-col>
          <v-col>
            <v-sheet class="pa-2 ma-2">
              <component :is="currentComponent"/>
            </v-sheet>
          </v-col>
        </v-row>
      </v-container>
    </v-layout>
  </v-app>
</template>

<script setup lang="ts">
  import { computed, onMounted, ref, shallowRef, watch } from 'vue'
  import { registerAllModules } from 'handsontable/registry';
  import { useUI, useNotesStore, useTablesStore } from '@/stores/ui'
  import { textEditorControl } from '@/stores/TextEditor'
  import MediaAccess from './MediaAccess.vue'
  import Settings from './Settings.vue'
  import TextEditor from './TextEditor.vue'
  import TableEditor from './TableEditor.vue'

  import { server } from '../api/server'

  console.debug('UI Component loaded!')


  interface Note {
    f_path_name: string
    text_content: string
  }
  
  interface Table {
    f_path_name: string
    text_content: string
  }


  type GroupItem = {
    title: string
    icon: string
    value: string
  }

  const ui = useUI()
  const text_editor_ctrl = textEditorControl()
  const notesStore = useNotesStore()
  const tablesStore = useTablesStore()

  /*
  - - - - Server Interaction - - - -
  */
  const message = ref<string>('')
  const notes_list = ref<Note[]>([])
  const note_titles = ref<GroupItem[]>([])
  
  
  // Do it here first and only once for better performance
  registerAllModules();



  onMounted(async () => {
    message.value = await server.check_default()
    console.debug('Server Resp:', message.value?.msg)

    notesStore.fetchNotes()
    tablesStore.fetchTables()
  })

  watch(
    () => notesStore.notes,
    (newNotes) => {
      if (!newNotes) return
      notes_list.value = newNotes
      note_titles.value = newNotes.map(note => ({
        title: note.f_path_name.split('/').pop() ?? note.f_path_name,
        icon: 'mdi-text-box',
        value: note.f_path_name
      }))
    },
    { immediate: true }
  )


  const selectedNotePath = computed(() => {
    const val = ui.selected[0]
    return typeof val === 'string' ? val : null
  })

  const selectedNote = computed(() => {
    if (!selectedNotePath.value) return null
    return notes_list.value.find(n => n.f_path_name === selectedNotePath.value) ?? null
  })

  watch(selectedNote, (note) => {
    if (!note) return
    text_editor_ctrl.pushText(note)
  })
  
  
  const table_list = ref<Table[]>([])
  const table_titles = ref<GroupItem[]>([])
  
  
  watch(
    () => tablesStore.tables,
    (newTables) => {
      if (!newTables) return
      table_list.value = newTables
      table_titles.value = newTables.map(table => ({
        title: table.f_path_name.split('/').pop() ?? table.f_path_name,
        icon: 'mdi-text-box',
        value: table.f_path_name
      }))
    },
    { immediate: true }
  )
  
  const selectedTablePath = computed(() => {
    const val = ui.selected[0]
    return typeof val === 'string' ? val : null
  })
  
  const selectedTable = computed(() => {
    if (!selectedTablePath.value) return null
    return table_list.value.find(n => n.f_path_name === selectedTablePath.value) ?? null
  })

  /*
  - - - - Sidebar Functionality - - - -
  */

  const currentComponent = computed(() => {
    if (ui.opened.includes('notes'))
      return TextEditor
    if (ui.opened.includes('tables'))
      return TableEditor
    if (ui.selected.includes('media-access'))
      return MediaAccess
    if (ui.selected.includes('settings'))
      return Settings
    return null
  })
  
</script>