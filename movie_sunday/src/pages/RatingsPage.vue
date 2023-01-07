<template>
  <q-page class="flex column">
    <div class="q-pa-md q-gutter-md">
      <q-card v-for="rating in ratings" :key="rating" bordered>
        <q-card-section horizontal class="col-8">
          <q-icon name="camera" class="col-1" size="xl" color=primary />
          <q-card-section class="col-2">
            <div>{{ rating.series_title }}</div>
          </q-card-section>
          <q-card-section class="col-2">
            <div>{{ toTitleCase(rating.series_chosen_by) }}</div>
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
            <div>{{ parseFloat(rating.series_rating).toFixed(2) }}%</div>
          </q-card-section>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script>
import { defineComponent } from 'vue'
import axios from 'axios'

export default defineComponent({
  name: 'RatingsPage',
  data() {
    return {
      ratings: null
    }
  },
  async created() {
    const response = await axios.get("http://localhost:1234/ratings")
    this.ratings = response.data
  },
  methods: {
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    }
  }
})
</script>
