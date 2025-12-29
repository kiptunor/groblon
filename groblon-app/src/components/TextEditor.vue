<template>
  
    <v-card>
      <v-toolbar color="primary-light">
        <!--
        To add:
        - Note properties (File properties)
        -->
        <v-div class="mr-2"></v-div>
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

        <v-text-field class="mt-6" style="max-width: 300px; width: 100%;" label="Search text" variant="solo-filled"></v-text-field>
        
        <v-btn
          color="grey-500"
          variant="elevated"
          v-tooltip:bottom="'Note properties'"
          class="ml-3"
          icon="mdi-information-slab-box"
        ></v-btn>
      </v-toolbar>
    </v-card>
    <v-textarea
      v-model="text_editor_ctrl.textarea_string"
      class="mt-2 fill-textarea"
      label="text"
      rows="19"
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
  
</template>

<script setup lang="ts">
  import { computed, ref, shallowRef, watch } from 'vue'
  import { server } from '../api/server'
  import { textEditorControl } from '@/stores/TextEditor'
  import { useUI, useNotesStore } from '@/stores/ui'


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
    { color: 'info-darken-1', icon: 'mdi-text-box-plus-outline', tooltip: 'Add Note' },
    { color: 'red', icon: 'mdi-text-box-minus-outline', tooltip: 'Remove Selected Note' },
    { color: 'primary', icon: 'mdi-refresh', tooltip: 'Refresh note list' },
  ]

  // Tried to fix that issue somehow XDDDD
  const dialActionsReversed = [...dialActions].reverse()

  function onDialAction(item, index) {
    if (item.icon === 'mdi-text-box-plus-outline') {
      noteName.value = ''
      noteDialog.value = true
    }
    if (item.icon === 'mdi-text-box-minus-outline') {
      // Todo: Add warning dialog
      server.delete_note(current_file_path.value)
      notesStore.fetchNotes()
    }
    if (item.icon === 'mdi-refresh') {
      notesStore.fetchNotes()
      // console.log('Refresh note list action')
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
    // console.log('Creating note...')
    server.create_note(noteName.value)

    notesStore.fetchNotes()
  }

  const textarea_string = ref('')
  let timeout: number | undefined
  let saveRefreshTimeout: number | undefined;
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
      clearTimeout(saveRefreshTimeout);

      timeout = window.setTimeout(() => {
        // console.log('Saving action:', current_file_path.value)
        server.save_note({
          filename: current_file_path.value,
          content: newValue
        })
        
        saveRefreshTimeout = window.setTimeout(() => {
          notesStore.fetchNotes()
        }, 500)
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