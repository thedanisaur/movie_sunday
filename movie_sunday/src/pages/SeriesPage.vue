<template>
  <q-page class="flex flex-left column">

    <div class="q-pa-md q-gutter-md">
      <q-card v-for="series in seriess" :key="series" bordered>
        <q-card-section horizontal class="col-4">
          <!-- <q-parallax 
            src="../assets/module-6.jpg"
            :height="65 + series.movies.length * 65"
          /> -->
          <q-img src="../assets/module-6.jpg"/>

          <q-card-section class="col-8">
            <!-- HEADER -->
            <q-card-section horizontal>
              <q-item class="col-12">
                <q-item-section class="text-h6 q-pa-md q-gutter-md">{{ series.name }}</q-item-section>
                <q-item-section side>
                  <q-item-label class="text-h6 q-pa-md q-gutter-md">#39</q-item-label>
                </q-item-section>
              </q-item>
              <!-- <q-item class="text-h6 q-pa-md q-gutter-md">{{ series.name }}</q-item>
              <q-item class="text-h6 q-pa-md q-gutter-md">#39</q-item> -->
            </q-card-section>
            <q-separator />
            <!-- BODY -->
            <q-card-section v-for="movie in series.movies" :key="movie">
              <q-card-section horizontal class="col-8">
                <div class="text-subtitle2 q-pa-md q-gutter-md">{{ movie }}</div>
                <div class="text-subtitle2 q-pa-md q-gutter-md">Good</div>
                <div class="text-subtitle2 q-pa-md q-gutter-md">Bad</div>
                <div class="text-subtitle2 q-pa-md q-gutter-md">%</div>
              </q-card-section>
            </q-card-section>
            <!-- FOOTER -->
            <q-card-section horizontal>
              <q-item dense class="col-12">
                <q-item-section>
                  <q-item-label>Dan</q-item-label>
                </q-item-section>
              </q-item>
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
