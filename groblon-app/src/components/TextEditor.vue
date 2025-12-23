<template>
  <v-main>
    <v-card>
      <v-toolbar>
        <!--
        To add:
        - Note properties (File properties)
        -->
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
              v-tooltip="{ location: tooltipLocation, text: item.tooltip }"
              :color="item.color"
              :icon="item.icon"
              @click="onDialAction(item, i)"
            ></v-btn>
          </v-speed-dial>
        </v-btn>

        <v-btn
          v-tooltip:bottom="'Search text'"
          class="ml-3"
          icon="mdi-magnify"
        ></v-btn>
      </v-toolbar>
    </v-card>
    <v-textarea
      v-model="text_editor_ctrl.textarea_string"
      class="mt-2"
      label="text"
      rows="35"
      variant="solo-filled"
      @blur="isTextareaFocused = false"
      @focus="isTextareaFocused = true"
    ></v-textarea>

    <div class="pa-4 text-center">
      <v-dialog
        v-model="noteDialog"
        max-width="600"
      >
        <v-card
          prepend-icon="mdi-text-box"
          title="Create new note"
        >
          <v-card-text>
            <v-text-field
              v-model="noteName"
              label="Name"
              required
              :rules="noteNameRule"
              variant="solo-filled"
            ></v-text-field>

            <v-checkbox
              v-model="defaultFileExt"
              color="primary"
              hide-details
              label="Append default file extension"
              value="auto-extension"
            ></v-checkbox>
          </v-card-text>

          <v-divider></v-divider>

          <v-card-actions>
            <v-spacer></v-spacer>

            <v-btn
              text="Cancel"
              variant="plain"
              @click="noteDialog = false"
            ></v-btn>

            <v-btn
              color="primary"
              :disabled="!noteName"
              text="Create"
              variant="tonal"
              @click="createNote()"
            ></v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </div>
  </v-main>
</template>

<script setup lang="ts">
  import { computed, ref, shallowRef, watch } from 'vue'
  import { server } from '../api/server'
  import { textEditorControl } from '@/stores/TextEditor'
  import { useUI, useNotesStore } from '@/stores/ui'

  console.log('Text Editor Activated')

  const noteDialog = shallowRef(false)
  const noteName = ref('')
  const defaultFileExt = ref(false)
  
  const text_editor_ctrl = textEditorControl()
  const ui = useUI()
  const notesStore = useNotesStore()

  /*
  - - - - Toolbar functionality - - - -
  */

  // The order is reversed for some reason which I think it's very funny
  const dialActions = [
    { color: 'orange', icon: 'mdi-plus', tooltip: 'Add Note' },
    { color: 'red', icon: 'mdi-trash-can', tooltip: 'Remove Selected Note' },
    { color: 'primary', icon: 'mdi-refresh', tooltip: 'Refresh note list' },
  ]

  // Tried to fix that issue somehow XDDDD
  const dialActionsReversed = [...dialActions].reverse()

  function onDialAction(item, index) {
    // console.log('Clicked:', item.tooltip, 'at index', index)

    if (item.icon === 'mdi-plus') {
      console.log('Add note action')
      noteName.value = ''
      noteDialog.value = true
    }
    if (item.icon === 'mdi-trash-can') {
      // Todo: Add warning dialog
      console.log('Remove note action')
      server.delete_note('< Temp Name >')
    }
    if (item.icon === 'mdi-refresh') {
      notesStore.fetchNotes()
      console.log('Refresh note list action')
      // server.refresh_note_list()
    }
  }


  function createNote() {
    /*
    Sends http request to create a new note as an empty text file
    */

    noteDialog.value = false

    // Why can't js do this easier
    if (defaultFileExt.value && !noteName.value.endsWith('.txt')) {
      noteName.value += '.txt'
    }
    console.log('Creating note...')
    server.create_note(noteName.value)
    
    notesStore.fetchNotes()
  }
  
  const textarea_string = ref('')
  let timeout: number | undefined
  const isTextareaFocused = ref(false)

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


  watch(
    () => text_editor_ctrl.textarea_string,
    (newValue) => {
      if (!isTextareaFocused.value) return

      clearTimeout(timeout)

      timeout = window.setTimeout(() => {
        // console.log('Saving action:', current_file_path.value)
        server.save_note({
          filename: current_file_path.value,
          content: newValue
        })
      }, 1000)
    }
  )

  watch(
    () => text_editor_ctrl.textarea_string,
    (newVal) => {
      textarea_string.value = newVal
    }
  )
</script>