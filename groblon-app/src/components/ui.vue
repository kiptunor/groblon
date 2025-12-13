<template>
  <v-container class="fill-height position-absolute left-0">
    <v-card class="pa-2 fill-height" max-width="300">
      <v-list v-model:active="active" v-model:opened="opened" v-model:selected="selected" density="proeminent">
        <v-list-group color="primary" value="Notes">
          <template #activator="{ props }">
            <v-list-item
              class="mb-2"
              color="primary"
              v-bind="props"
              prepend-icon="mdi-sticker-text"
              rounded="xl"
              title="Notes"></v-list-item>
          </template>

          <v-list-item
            v-for="([title, icon], i) in noteExamples"
            :key="i"
            class="mb-2"
            :prepend-icon="icon"
            rounded="xl"
            :title="title"
            :value="title"
          ></v-list-item>
        </v-list-group>

        <!--Media Access-->
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          class="mb-2"
          color="primary"
          rounded="xl"
          :value="item"
        >
          <template #prepend>
            <v-icon :icon="item.icon"></v-icon>
          </template>
          <v-list-item-title v-text="item.text"></v-list-item-title>
        </v-list-item>
      </v-list>
    </v-card>
  </v-container>
</template>


<script lang="ts">

</script>

<script setup lang="ts">
import { watch, shallowRef } from 'vue'

console.log("UI Component loaded!");

const items = [
  { text: 'Media Access', value: 'media-acc', icon: 'mdi-multimedia' },
  { text: 'Settings', value: 'Settings', icon: 'mdi-cog' },
]

// Just some placeholder for now
const noteExamples = [
  ['Some Note idk', 'mdi-text-box'],
  ['links', 'mdi-text-box'],
  ['Names', 'mdi-text-box'],
  ['samples', 'mdi-text-box'],
]



const opened = shallowRef<string[]>([])
const active = shallowRef<string[]>([])
const selected = shallowRef<string[]>([])

//watch(opened, (val) => {
//  //console.log('Opened groups:', val)
//  console.log('Is Notes open?', val.includes('Notes'))
//  //console.log('Is Media Access clicked?', val.includes('Media Access'))
//})
//
//watch(active, (val) => {
//  console.log('Active items:', val)
//})

watch(selected, (val) => {
  console.log('Selected items:', val.includes('Media Access'))
})

</script>