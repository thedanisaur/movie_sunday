<template>
  <q-page class="flex">
    <div class="q-pa-md q-gutter-md row flex-center">
      <q-card v-for="series in timeline" :key="series" bordered style="min-height: 200px">
          <q-card-section class="col-8">
            <!-- HEADER -->
            <q-parallax src="../assets/module-6.jpg" :height="100" style="opacity: 0.8;">
              <q-item dense class="absolute-bottom text-h5 text-white text-weight-bolder q-ma-sm" style="text-shadow: 2px 2px black;">{{ series.series_title }}
                <q-badge floating transparent color="grey-10" align="bottom">Chosen By: {{ toTitleCase(series.series_chosen_by) }}</q-badge>
              </q-item>
              <q-badge floating transparent color="grey-10" align="top" class="text-h6 text-weight-bold">Rank: {{ series.series_rank + 1 }}</q-badge>
            </q-parallax>
            <q-card-section horizontal>
                <q-item-section class="col-6">
                </q-item-section>
                <q-item dense class="col-2">Dan</q-item>
                <q-item dense class="col-2">Nick</q-item>
                <q-item dense class="col-2">{{ parseFloat(series.series_rating).toFixed(1) }}%</q-item>
            </q-card-section>
            <q-separator />
            <!-- BODY -->
            <div v-if="series.series_movies">
              <q-scroll-area style="height: 200px; min-width:350px;">
                <q-card-section v-for="movie in series.series_movies" :key="movie" class="bg-grey-2">
                  <q-card-section horizontal>
                    <q-item dense class="col-6">{{ movie.movie_title }}</q-item>
                    <q-space />
                    <q-icon dense v-if="movie.dan_vote == 'GOOD'" name="thumb_up" size="sm" color=secondary class="col-2" />
                    <q-icon dense v-else name="thumb_down" size="sm" color=red class="col-2" />
                    <q-space />
                    <q-icon dense v-if="movie.nick_vote == 'GOOD'" name="thumb_up" size="sm" color=secondary class="col-2" />
                    <q-icon dense v-else name="thumb_down" size="sm" color=red class="col-2" />
                    <q-space />
                    <q-icon dense :name="calcSmiley(movie.dan_vote, movie.nick_vote).smiley" size="md" :color="calcSmiley(movie.dan_vote, movie.nick_vote).color" class="col-2" />
                  </q-card-section>
                  <q-separator />
                </q-card-section>
              </q-scroll-area>
            </div>
            <div v-else>
              <q-card-section class="bg-grey-2" style="min-height:200px; min-width: 350px;">
                <q-card-section horizontal>
                  <q-item dense>No data available yet for "{{ series.series_title }}"</q-item>
                </q-card-section>
                <q-separator />
              </q-card-section>
            </div>
            <!-- FOOTER -->
            <q-card-section horizontal>
              <q-badge floating transparent color="grey-10">Series: #{{ series.series_order }}</q-badge>
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
  name: 'TimelinePage',
  data() {
    return {
      timeline: null
    }
  },
  async created() {
    const response = await axios.get("http://localhost:1234/timeline")
    this.timeline = response.data
  },
  methods: {
    calcSmiley(dan_vote, nick_vote) {
      let d = 0.0
      let n = 0.0
      if (dan_vote == "GOOD") {
        d = 1.0
      }
      if (nick_vote == "GOOD") {
        n = 1.0
      }
      const value = (d + n) / 2
      if (value > .5) {
        return {smiley: "mood", color: "secondary"}
      } else if (value == .5) {
        return {smiley: "sentiment_neutral", color: "primary"}
      } else {
        return {smiley: "mood_bad", color: "red"}
      }
    },
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    }
  }
})
</script>
