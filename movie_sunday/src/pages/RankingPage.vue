<template>
  <q-page class="flex column">
      <q-header class="q-ma-sm bg-white" style="position:fixed; top:52px; color:black;">
        <q-card bordered>
          <q-card-section horizontal class="col-8">
            <q-icon name="movie" class="col-1" size="xl" color=primary />
            <q-card-section class="col-2">
              <q-card-section horizontal>
                <q-icon name="camera_roll" size="md" color=primary />
                <q-item class="q-pa-md q-gutter-md q-pl-lg">Series</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
            <q-card-section class="col-2">
              <q-card-section horizontal>
                <q-icon name="accessible" size="md" color=primary />
                <q-item class="q-pa-md q-gutter-md q-pl-lg">Chosen By</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
            <q-card-section class="col-2">
              <q-card-section horizontal>
                <q-icon name="tag" size="md" color=primary />
                <q-item class="q-pa-md q-gutter-md q-pl-lg">Number of Movies</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
            <q-card-section class="col-2">
              <q-card-section horizontal>
                <q-icon name="thumb_up" size="md" color=primary />
                <q-item class="q-pa-md q-gutter-md q-pl-lg">Good</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
            <q-card-section class="col-2">
              <q-card-section horizontal>
                <q-icon name="thumb_down" size="md" color=primary />
                <q-item class="q-pa-md q-gutter-md q-pl-lg">Bad</q-item>
              </q-card-section>
              <q-separator />
            </q-card-section>
            <q-card-section class="col-1">
              <q-card-section horizontal>
                <q-icon name="star" size="md" color=primary />
                <q-item class="q-pa-md q-gutter-md q-pl-lg">Rating</q-item>
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
      <q-card v-for="rank in ranks" :key="rank" bordered>
        <q-card-section horizontal class="col-8">
          <q-icon name="camera" class="col-1" size="xl" color=primary />
          <q-card-section class="col-2">
            <div>{{ rank.series }}</div>
          </q-card-section>
          <q-card-section class="col-2">
            <div>{{ toTitleCase(rank.chosen_by) }}</div>
          </q-card-section>
          <q-card-section class="col-2">
            <div>{{ rank.movies_in_series }}</div>
          </q-card-section>
          <q-card-section class="col-2">
            <div>{{ rank.good_votes }}</div>
          </q-card-section>
          <q-card-section class="col-2">
            <div>{{ rank.bad_votes }}</div>
          </q-card-section>
          <q-card-section class="col-1">
            <div>{{ parseFloat(rank.rating).toFixed(2) }}%</div>
          </q-card-section>
        </q-card-section>
      </q-card>
    </div>
  </q-page>

  <!-- <q-page class="flex flex-center">
    <q-label>
      Ranking!
    </q-label>
  </q-page> -->
</template>

<script>
import { defineComponent } from 'vue'
// import axios from 'axios'
import rankData from "../assets/ranking.json"

export default defineComponent({
  name: 'RankingPage',
  data() {
    return {
      ranks: rankData
    }
  },
  created() {
    // const response = await axios.get("https://localhost:1234/ranking")
    // console.log(response.data)
    // alert(ranking)
    // console.log(data.ranks)
  },
  methods: {
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    }
  }
})
</script>
