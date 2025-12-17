<template>
  <UI ref="uiRef" />
  <div class="text-center pa-4">
    <v-dialog
      v-model="settingsDialog"
      fullscreen
      transition="dialog-bottom-transition"
    >
      <v-card>
        <v-toolbar>
          <v-btn
            icon="mdi-close"
            @click="closeSettingsDialog()"
          ></v-btn>

          <v-toolbar-title>Settings</v-toolbar-title>

          <v-toolbar-items>
            <v-btn
              text="Save"
              variant="text"
              @click="saveSettings()"
            ></v-btn>
          </v-toolbar-items>
        </v-toolbar>

        <v-list lines="two">
          <v-list-subheader>User Controls</v-list-subheader>

          <v-list-item
            link
            subtitle="Set the content filtering level to restrict apps that can be downloaded"
            title="Content filtering"
          ></v-list-item>

          <v-list-item
            link
            subtitle="Require password for purchase or use password to restrict purchase"
            title="Password"
          ></v-list-item>

          <v-divider></v-divider>

          <v-list-subheader>General</v-list-subheader>

          <v-list-item
            subtitle="Notify me about updates to apps or games that I downloaded"
            title="Notifications"
            @click="notifications = !notifications"
          >
            <template v-slot:prepend>
              <v-list-item-action start>
                <v-checkbox-btn v-model="notifications" color="primary"></v-checkbox-btn>
              </v-list-item-action>
            </template>
          </v-list-item>

          <v-list-item
            subtitle="Auto-update apps at any time. Data charges may apply"
            title="Sound"
            @click="sound = !sound"
          >
            <template v-slot:prepend>
              <v-list-item-action start>
                <v-checkbox-btn v-model="sound" color="primary"></v-checkbox-btn>
              </v-list-item-action>
            </template>
          </v-list-item>

          <v-list-item
            subtitle="Automatically add home screen widgets"
            title="Auto-add widgets"
            @click="widgets = !widgets"
          >
            <template v-slot:prepend>
              <v-list-item-action start>
                <v-checkbox-btn v-model="widgets" color="primary"></v-checkbox-btn>
              </v-list-item-action>
            </template>
          </v-list-item>
        </v-list>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup>
  import { shallowRef, ref } from 'vue'
  import { useUI } from '@/stores/ui'
  // import UI from './ui.vue'

  const settingsDialog = shallowRef(true)
  const notifications = shallowRef(false)
  const sound = shallowRef(true)
  const widgets = shallowRef(false)

  const ui = useUI()

  function closeSettingsDialog() {
    settingsDialog.value = false
    ui.clearSelection() // works everywhere
  }

  function saveSettings() {
    // Save settings logic here
    settingsDialog.value = false
    ui.clearSelection()
    console.log('Settings saved')
  }
</script>