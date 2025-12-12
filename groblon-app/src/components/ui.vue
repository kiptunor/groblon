<template>
  <v-container class="fill-height position-absolute left-0">
    <v-card class="pa-2 fill-height" max-width="300">
      <v-list density="proeminent">
        <!--<v-list-subheader>REPORTS</v-list-subheader>-->

        <v-list-group value="Notes" color="primary">
          <template v-slot:activator="{ props }">
            <v-list-item
              color="primary"
              class="mb-2"
              v-bind="props"
              prepend-icon="mdi-sticker-text"
              rounded="xl"
              title="Notes"></v-list-item>
          </template>

          <v-list-item
            rounded="xl"
            v-for="([title, icon], i) in noteExamples"
            :key="i"
            class="mb-2"
            :prepend-icon="icon"
            :title="title"
            :value="title"></v-list-item>
        </v-list-group>

        <!--Media Access-->
        <v-list-item
          class="mb-2"
          v-for="(item, i) in items"
          :key="i"
          :value="item"
          color="primary"
          rounded="xl">
          <template v-slot:prepend>
            <v-icon :icon="item.icon"></v-icon>
          </template>
          <v-list-item-title v-text="item.text"></v-list-item-title>
        </v-list-item>
      </v-list>
    </v-card>
  </v-container>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const items = [
  //{ text: 'Notes', icon: 'mdi-sticker-text' },
  { text: 'Media Access', icon: 'mdi-multimedia' },
  { text: 'Settings', icon: 'mdi-cog' },
]


const open = ref(['Notes'])

// Just some placeholder for now
const noteExamples = [
  ['Some Note idk', 'mdi-text-box'],
  ['links', 'mdi-text-box'],
  ['Names', 'mdi-text-box'],
  ['samples', 'mdi-text-box'],
]

</script>
