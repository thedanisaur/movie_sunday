<template>
  <q-page class="flex column">
      <q-header class="q-ma-sm bg-white" style="position:fixed; top:52px; color:black;">
        <q-card bordered>
          <q-card-section horizontal class="col-8">
            <q-icon name="movie" class="col-1" size="xl" color=primary />
            <q-card-section class="col-2">
              <q-card-section horizontal>
                <q-icon name="camera_roll" size="md" color=primary />
                <q-item class="q-pa-sm q-gutter-md q-pl-lg q-mt-xs">Series</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
            <q-card-section class="col-2">
              <q-card-section horizontal>
                <q-icon name="accessible" size="md" color=primary />
                <q-item class="q-pa-sm q-gutter-md q-pl-lg q-mt-xs">Chosen By</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
            <q-card-section class="col-2">
              <q-card-section horizontal>
                <q-icon name="tag" size="md" color=primary />
                <q-item class="q-pa-sm q-gutter-md q-pl-lg q-mt-xs">Number of Movies</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
            <q-card-section class="col-2">
              <q-card-section horizontal>
                <q-icon name="thumb_up" size="md" color=primary />
                <q-item class="q-pa-sm q-gutter-md q-pl-lg q-mt-xs">Good</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
            <q-card-section class="col-2">
              <q-card-section horizontal>
                <q-icon name="thumb_down" size="md" color=primary />
                <q-item class="q-pa-sm q-gutter-md q-pl-lg q-mt-xs">Bad</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
            <q-card-section class="col-1">
              <q-card-section horizontal>
                <q-icon name="star" size="md" color=primary />
                <q-item class="q-pa-sm q-gutter-md q-pl-lg q-mt-xs">Rating</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
          </q-card-section>
        </q-card>
      </q-header>
    <div class="q-pa-md q-gutter-md">
      <q-card>
        <q-card-section horizontal class="col-8">
          <q-card-section :height="25">
          </q-card-section>
        </q-card-section>
      </q-card>
      <q-card v-for="rating in ratings" :key="rating" bordered>
        <q-card-section horizontal class="col-8">
          <q-icon name="camera" class="col-1" size="xl" color=primary />
          <q-card-section class="col-2">
            <div>{{ rating.series }}</div>
          </q-card-section>
          <q-card-section class="col-2">
            <div>{{ toTitleCase(rating.chosen_by) }}</div>
          </q-card-section>
          <q-card-section class="col-2">
            <div>{{ rating.movies_in_series }}</div>
          </q-card-section>
          <q-card-section class="col-2">
            <div>{{ rating.good_votes }}</div>
          </q-card-section>
          <q-card-section class="col-2">
            <div>{{ rating.bad_votes }}</div>
          </q-card-section>
          <q-card-section align="right" class="col-1">
            <div>{{ parseFloat(rating.rating).toFixed(2) }}%</div>
          </q-card-section>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script>
import { defineComponent } from 'vue'
// import axios from 'axios'
import ratingData from "../assets/rating.json"

export default defineComponent({
  name: 'RatingPage',
  data() {
    return {
      ratings: ratingData
    }
  },
  created() {
    // const response = await axios.get("https://localhost:1234/rating")
    // console.log(response.data)
  },
  methods: {
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    }
  }
})
</script>
