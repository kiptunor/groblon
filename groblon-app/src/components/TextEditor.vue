<template>
  <v-card>
    <v-toolbar>
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
  <v-textarea class="mt-2" label="text" rows="35" variant="solo-filled"></v-textarea>
  
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
            label="Name"
            required
          ></v-text-field>

          <v-checkbox
            color="primary"
            hide-details
            label="Append default file extension"
            value="auto-extension"
          ></v-checkbox>

          <!--<small class="text-caption text-medium-emphasis">*indicates required field</small>-->
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
            text="Save"
            variant="tonal"
            @click="noteDialog = false, createNote()"
          ></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup lang="ts">
  import { shallowRef } from 'vue'

  console.log('Text Editor Activated')

  const noteDialog = shallowRef(false)

  /*
  - - - - Toolbar functionality - - - -
  */

  // The order is reversed for some reason which I think it's very funny
  const dialActions = [
    { color: 'primary', icon: 'mdi-plus', tooltip: 'Add Note' },
    { color: 'primary', icon: 'mdi-minus', tooltip: 'Remove Selected Note' },
  ]

  // Tried to fix that issue somehow XDDDD
  const dialActionsReversed = [...dialActions].reverse()

  function onDialAction(item, index) {
    // console.log('Clicked:', item.tooltip, 'at index', index)

    if (item.icon === 'mdi-plus') {
      console.log('Add note action')
      noteDialog.value = true
    }
    if (item.icon === 'mdi-minus') {
      // Todo: Add warning dialog
      console.log('Remove note action')
    }
  }

  function createNote() {
    /*
    Sends http request to create a new note as an empty text file
    */
    console.log('Creating note...')
  }
</script>