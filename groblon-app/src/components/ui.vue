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
              title="Notes"
            ></v-list-item>
          </template>

          <!-- Render the notes list-->
          <v-list-item
            v-for="item in noteExamples"
            :key="item.value"
            class="mb-2"
            :prepend-icon="item.icon"
            rounded="xl"
            :title="item.title"
            :value="item.value"
          ></v-list-item>
        </v-list-group>

        <v-list-item
          class="mb-2"
          color="primary"
          label="Media Access"
          rounded="xl"
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
          rounded="xl"
          value="settings"
        >
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
  import { computed, shallowRef, watch } from 'vue'

  console.log('UI Component loaded!')



  type NoteItem = {
    title: string
    icon: string
    value: string
  }


  /*
  - - - - Sidebar Functionality - - - -
  */

  const titles = ['Some Note idk', 'links', 'Names', 'samples']

  const noteExamples: NoteItem[] = titles.map(title => ({
    title,
    icon: 'mdi-text-box',
    value: title.toLowerCase().replace(/\s+/g, '-'),
  }))

  const opened = shallowRef<string[]>([])
  const selected = shallowRef<string[]>([])


  // Handling sidebar items independently
  const isNotesActive = computed(() =>
    opened.value.includes('notes')
  )

  const isMediaAccessActive = computed(() =>
    selected.value.includes('media-access')
  )

  const isSettingsActive = computed(() =>
    selected.value.includes('settings')
  )

  // Check the state of each list item
  // Todo: Render the required components (Text editor for notes, image / video / audio player, app settings)
  watch(isMediaAccessActive, val => {
    if (val) {
      console.log('Media Access')
    }
  })

  watch(isSettingsActive, val => {
    if (val) {
      console.log('Settings')
    }
  })

  watch(isNotesActive, val => {
    if (val) {
      console.log('Notes')
    }
  })
</script>