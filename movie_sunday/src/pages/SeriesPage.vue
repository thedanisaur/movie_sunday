<template>
  <q-page class="flex flex-left column">

    <div class="q-pa-md q-gutter-md">
      <q-card v-for="series in seriess" :key="series" bordered>
        <q-card-section horizontal class="col-4">
          <q-parallax 
            src="https://cdn.quasar.dev/img/mountains.jpg"
            :height="65 + series.movies.length * 65"
          />

          <q-card-section class="col-8">
            <div class="text-h6 q-pa-md q-gutter-md">{{ series.name }}</div>
            <q-separator />
            <q-card-section v-for="movie in series.movies" :key="movie">
              <div class="text-subtitle2">{{ movie }}</div>
            </q-card-section>
          </q-card-section>
        </q-card-section>
      </q-card>
    </div>

  </q-page>
</template>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'SeriesPage',
  setup () {
    return {
      seriess : {
        0 : {
            name : 'star wars',
            movies : ['a new hope', 'empire strikes back', 'return of the jedi', 'a phantom menace', 'clone wars', 'revenge of the sith'],
        },
        1 : {
          name : 'terminator',
          movies : ['terminator 1', 'terminator 2', 'terminator 3'],
        },
        2 : {
          name : 'saw',
          movies : ['saw', 'saw 2', 'saw 3', 'saw 4', 'saw 5', 'saw 6', 'saw 7', 'saw 8'],
        },
        3 : {
          name : 'jurassic park',
          movies : ['jurassic park', 'jurassic park 2', 'jurassic park 3'],
        },
      }
    }
  }
})
</script>
