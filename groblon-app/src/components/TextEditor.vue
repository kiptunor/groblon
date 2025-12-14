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
</template>

<script setup lang="ts">

  console.log('Text Editor Activated')

  // The order is reversed for some reason which I think it's very funny
  const dialActions = [
    { color: 'primary', icon: 'mdi-plus', tooltip: 'Add Note' },
    { color: 'primary', icon: 'mdi-minus', tooltip: 'Remove Selected Note' },
  ]

  // Tried to fix that issue somehow XDDDD
  const dialActionsReversed = [...dialActions].reverse()
</script>