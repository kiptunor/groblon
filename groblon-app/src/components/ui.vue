<template>
  <v-app>
    <v-layout>
      <v-container class="pa-0 ma-0" fluid>
        <v-row class="fill-height" no-gutters>
          <v-col cols="auto">
            <v-card class="pa-2 fill-height" max-width="300">
              <v-list v-model:opened="ui.opened" v-model:selected="ui.selected" selectable density="proeminent">
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
                  @click="settingsDialog = true"
                >
                  <template #prepend>
                    <v-icon icon="mdi-cog" />
                  </template>
                  <v-list-item-title>Settings</v-list-item-title>
                </v-list-item>
              </v-list>
            </v-card>
          </v-col>
          <v-col class="pa-2">
            <component :is="currentComponent" />
          </v-col>
        </v-row>
      </v-container>
    </v-layout>
  </v-app>
</template>

<script setup lang="ts">
  import { computed, ref, shallowRef, watch, onMounted } from 'vue'
  // import { defineStore } from 'pinia'
  import { useUI } from '@/stores/ui'
  import MediaAccess from './MediaAccess.vue'
  import Settings from './Settings.vue'
  import TextEditor from './TextEditor.vue'

  import { server } from '../api/server'

  console.log('UI Component loaded!')



  type NoteItem = {
    title: string
    icon: string
    value: string
  }

  const ui = useUI()

  /*
  - - - - Sidebar Functionality - - - -
  */

  const titles = ['Some Note idk', 'links', 'Names', 'samples']

  const noteExamples: NoteItem[] = titles.map(title => ({
    title,
    icon: 'mdi-text-box',
    value: title.toLowerCase().replace(/\s+/g, '-'),
  }))

  /*
  - - - - Components Rendering - - - -
  */

  const currentComponent = computed(() => {
    if (ui.opened.includes('notes'))
      return TextEditor
    if (ui.selected.includes('media-access'))
      return MediaAccess
    if (ui.selected.includes('settings'))
      return Settings
    return null
  })


  const message = ref<string>('')


  onMounted(async () => {
    message.value = await server.check_default()
    console.log('Server Resp:', message.value?.msg)
  })



</script>