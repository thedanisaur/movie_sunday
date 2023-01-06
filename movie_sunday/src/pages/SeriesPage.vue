<template>
  <q-page class="flex flex-left column">
    <div class="q-pa-md q-gutter-md">
      <q-card v-for="series in timeline" :key="series" bordered>
        <q-card-section horizontal class="col-4">
          <!-- SERIES IMAGE -->
          <!-- <q-parallax 
            src="../assets/module-6.jpg"
            :height="65 + series.movies.length * 65"
          /> -->
          <q-img src="../assets/module-6.jpg"/>
          <q-separator vertical size=".5rem"/>
          <!-- SERIES INFORMATION -->
          <q-card-section class="bg-grey-4 col-8">
            <!-- HEADER -->
            <q-card-section horizontal>
              <q-item class="col-12">
                <q-item-section class="col-7">
                  <q-label class="text-h4 text-weight-bold">{{ series.series_title }}</q-label>
                </q-item-section>
                <q-label class="q-pt-xl col-2">Dan Vote</q-label>
                <q-label class="q-pt-xl col-2">Nick Vote</q-label>
                <q-item-section side class="col-1">
                  <q-btn round dense color=primary class="text-h5">
                    #{{ series.series_rank + 1 }}
                    <q-badge rounded floating color=secondary align="bottom">{{ parseFloat(series.series_rating).toFixed(1) }}%</q-badge>
                  </q-btn>
                </q-item-section>
              </q-item>
            </q-card-section>
            <q-separator />
            <!-- BODY -->
            <q-card-section v-for="movie in series.series_movies" :key="movie" class="bg-grey-2">
              <q-card-section horizontal>
                <q-label class="col-6">{{ movie.movie_title }}</q-label>
                <q-space />
                <q-icon dense v-if="movie.dan_vote == 'GOOD'" name="thumb_up" size="sm" color=secondary />
                <q-icon dense v-else name="thumb_down" size="sm" color=red />
                <q-space />
                <q-icon dense v-if="movie.nick_vote == 'GOOD'" name="thumb_up" size="sm" color=secondary />
                <q-icon dense v-else name="thumb_down" size="sm" color=red />
                <q-space />
                <q-icon dense :name="calcSmiley(movie.dan_vote, movie.nick_vote).smiley" size="md" :color="calcSmiley(movie.dan_vote, movie.nick_vote).color" />
              </q-card-section>
              <q-separator />
            </q-card-section> 
            <!-- FOOTER -->
            <q-card-section horizontal class="col-12">
              <q-label class="col-10"></q-label>
              <q-space />
              <q-btn rounded dense color=primary class="q-mt-sm col-2">Chosen By: {{ toTitleCase(series.series_chosen_by) }}</q-btn>
            </q-card-section>
          </q-card-section>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script>
import { defineComponent } from 'vue'
import timelineData from "../assets/timeline.json"

export default defineComponent({
  name: 'SeriesPage',
  data() {
    return {
      timeline: timelineData
    }
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
