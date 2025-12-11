<template>
  <!--<v-container class="fill-height" max-width=1200>-->
    <!--<h1>Stuff....</h1>-->

   <v-card rounded="0" theme="dark" flat class="fill-height">
     <v-window v-model="onboarding">
       <v-window-item v-for="n in length":key="`card-${n}`":value="n">
        <v-card class="d-flex justify-center align-center fill-height">
          <span class="text-h2">
            Card {{ n }}
          </span>
        </v-card>
      </v-window-item>
    </v-window>

    <v-card-actions class="justify-space-between">
      <v-btn icon="mdi-chevron-left" variant="plain" @click="prev"></v-btn>
      <v-item-group v-model="onboarding" class="text-center" mandatory>
        <v-item v-for="n in length":key="`btn-${n}`" v-slot="{ isSelected, toggle }":value="n">
          <v-btn :variant="isSelected ? 'outlined' : 'text'" icon="mdi-record" @click="toggle"></v-btn>
        </v-item>
      </v-item-group>
      <v-btn icon="mdi-chevron-right" variant="plain" @click="next"></v-btn>
    </v-card-actions>
  </v-card>
  <!--</v-container>-->
</template>

<script setup lang="ts">

  import { ref } from 'vue'

  // Text editor media viewer paging
  const length = ref(3)
  const onboarding = ref(1)

  function next () {
    onboarding.value = onboarding.value + 1 > length.value ? 1 : onboarding.value + 1
  }
  function prev () {
    onboarding.value = onboarding.value - 1 <= 0 ? length.value : onboarding.value - 1
  }

</script>
