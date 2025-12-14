<template>
  <v-carousel class="fill-height" hide-delimiters>
    <v-carousel-item
      v-for="(item,i) in items"
      :key="i"
      cover
      :src="item.src"
    ></v-carousel-item>
  </v-carousel>
</template>

<script setup>
  const items = [
    {
      src: 'https://cdn.vuetifyjs.com/images/carousel/squirrel.jpg',
    },
    {
      src: 'https://cdn.vuetifyjs.com/images/carousel/sky.jpg',
    },
    {
      src: 'https://cdn.vuetifyjs.com/images/carousel/bird.jpg',
    },
    {
      src: 'https://cdn.vuetifyjs.com/images/carousel/planet.jpg',
    },
  ]
</script>