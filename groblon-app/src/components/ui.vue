<!--The main sidebar menu-->
<template>
  <v-container class="fill-height position-absolute left-0">
    <v-card class="pa-2 fill-height" max-width="300">
      <v-list v-model:active="activeItems" v-model:opened="opened" v-model:selected="selected" density="proeminent">
        <v-list-group color="primary" value="notes">
          <template #activator="{ props }">
            <v-list-item
              class="mb-2"
              color="primary"
              v-bind="props"
              prepend-icon="mdi-sticker-text"
              rounded="xl"
              title="Notes"></v-list-item>
          </template>

          <!-- Render the notes -->
          <v-list-item
            v-for="([title, icon], i) in noteExamples"
            :key="i"
            class="mb-2"
            :prepend-icon="icon"
            rounded="xl"
            :title="title"
            :value="title"></v-list-item>
        </v-list-group>

        <v-list-item
          class="mb-2"
          color="primary"
          label="Media Access"
          rounded="xl"
          value="media-access">
          <template #prepend>
            <v-icon icon="mdi-multimedia" />
          </template>
          <v-list-item-title>Media Access</v-list-item-title>
        </v-list-item>

        <v-list-item
          class="mb-2"
          color="primary"
          label="Settings"
          rounded="xl"
          value="settings">
          <template #prepend>
            <v-icon icon="mdi-cog" />
          </template>
          <v-list-item-title>Settings</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-card>
  </v-container>
</template>


<script lang="ts">

</script>

<script setup lang="ts">
  import { shallowRef, watch } from 'vue'

  console.log('UI Component loaded!')


  /*
  - - - - Sidebar Functionality - - - -
  */

  // Just some placeholder for now
  const noteExamples = [
    ['Some Note idk', 'mdi-text-box'],
    ['links', 'mdi-text-box'],
    ['Names', 'mdi-text-box'],
    ['samples', 'mdi-text-box'],
  ]

  const opened = shallowRef<string[]>([])
  const selected = shallowRef<string[]>([])

  watch(opened, (val) => {
    console.log('Is Notes open?', val.includes('notes'))
  })

  // Didn't know this is the way to handle "click event" XDDD
  watch(selected, (val) => {
    console.log('Selected items:', val)
    console.log('Is Media Access selected?', val.includes('media-access'))
    console.log('Is Settings selected?', val.includes('settings'))
  })
</script>