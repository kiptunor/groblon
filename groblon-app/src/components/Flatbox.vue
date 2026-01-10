<template>
  <v-toolbar color="primary-light">
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
    
    <!--<v-text-field class="mt-6" style="max-width: 300px; width: 100%;" label="Search text" variant="solo-filled"></v-text-field>-->
    
    <v-btn
    color="grey-500"
    variant="elevated"
    v-tooltip:bottom="'Note properties'"
    class="ml-3"
    icon="mdi-information-slab-box"
    ></v-btn>
  </v-toolbar>
  <section>
    <v-container fluid class="scroll-container">
      <v-item-group selected-class="bg-primary">
        <v-container>
          <v-row>
            <v-col
              v-for="n in 14"
              :key="n"
              cols="12"
            >
              <v-item v-slot="{ isSelected, selectedClass, toggle }">
                <v-card
                  :class="['d-flex align-center', selectedClass]"
                  height="100"
                  class="w-100"
                  dark
                  @click="toggle"
                >
                <div class="text-h6 flex-grow-1 text-center">
                  {{ isSelected ? 'Selected' : 'Click Me!' }}
                </div>
                </v-card>
              </v-item>
            </v-col>
          </v-row>
        </v-container>
      </v-item-group>
    </v-container>
  </section>
  <v-textarea label="Send box" row-height="20" rows="2" variant="filled"></v-textarea>
  <div class="pa-4 text-center">
    <v-dialog
      v-model="flatboxDialog"
      max-width="600"
    >
      <v-card
        prepend-icon="mdi-text-box"
        title="Create flatbox"
      >
        <v-card-text>
          <v-text-field
            v-model="flatboxName"
            label="Name"
            required
            :rules="nflatboxNameRule"
            variant="solo-filled"
          ></v-text-field>
        </v-card-text>

        <v-divider></v-divider>

        <v-card-actions>
          <v-spacer></v-spacer>

          <v-btn
            text="Cancel"
            variant="plain"
            @click="flatboxDialog = false"
          ></v-btn>

          <v-btn
            color="primary"
            :disabled="!flatboxName"
            text="Create"
            variant="tonal"
            @click="createFlatbox()"
          ></v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<style scoped>
section, section * {
  user-select: text;
}

.scroll-container {
  max-height: 77vh;       /* or any height you want */
  overflow-y: auto;
}
</style>

<script setup lang="ts">
import { ref } from 'vue'
  console.log('Using Flatbox component');
  
  
  const dialActions = [
    { color: 'info-darken-1', icon: 'mdi-plus', tooltip: 'Create flatbox' },
    { color: 'red', icon: 'mdi-minus', tooltip: 'Remove flatbox' },
    { color: 'primary', icon: 'mdi-refresh', tooltip: 'Refresh flatbox list' },
  ]

  const dialActionsReversed = [...dialActions].reverse()

  function onDialAction(item, index) {
    if (item.icon === 'mdi-plus') {
      console.log('Create flatbox action')
      flatboxDialog.value = true
      flatboxName.value = ''
    }
    if (item.icon === 'mdi-minus') {
      console.log('Remove flatbox action')
    }
    if (item.icon === 'mdi-refresh') {
      console.log('Refresh flatbox list action')
    }
  }
  
  const flatboxDialog = ref(false)
  const flatboxName = ref('')
  
  function createFlatbox() {
    console.log('Creating flatbox')
    flatboxDialog.value = false
  }
</script>