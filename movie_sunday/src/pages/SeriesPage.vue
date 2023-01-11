<template>
  <q-page class="flex flex-center row">
    <q-toolbar class="absolute-top bg-grey-2">
      <q-btn
          size="md"
          color="primary"
          icon="add"
          @click="add = true"
          title="Add Series"
          label="Add Series"
        />
      <q-space />
      <q-btn-toggle
        v-model="ttr_toggle"
        size="md"
        title="Sort by Time/Title/Number of Movies/Rank"
        @click="sortSeries()"
        text-color="primary"
        :options="[
          { slot: 'time', value: 'series_order'},
          { slot: 'title', value: 'series_title'},
          { slot: 'movies', value: 'movies_in_series'},
          { slot: 'rank', value: 'series_rank'},
        ]"
        class="q-ma-sm"
      >
        <template v-slot:time>
          <q-icon name="history" />
        </template>
        <template v-slot:title>
          <q-icon name="movie" />
        </template>
        <template v-slot:movies>
          <q-icon name="list" />
        </template>
        <template v-slot:rank>
          <q-icon name="hotel_class" />
        </template>
      </q-btn-toggle>
      <q-btn-toggle
        v-model="ad_toggle"
        size="md"
        title="Sort Ascending/Descending"
        @click="sortSeries()"
        text-color="primary"
        :options="[
          { slot: 'ascending', value: 'ascending'},
          { slot: 'descending', value: 'descending'},
        ]"
        class="q-ma-sm"
      >
        <template v-slot:ascending>
          <q-icon name="arrow_upward" />
        </template>
        <template v-slot:descending>
          <q-icon name="arrow_downward" />
        </template>
      </q-btn-toggle>
    </q-toolbar>
    <q-infinite-scroll ref="iscroller" @load="onScroll" style="min-width: 100%">
      <div class="q-pa-md q-mt-xl q-gutter-md row flex-center">
        <q-card v-for="series in timeline" :key="series" bordered style="min-height: 200px;">
          <q-card-section>
            <q-parallax src="../assets/module-6.jpg" :height="100" style="opacity: 0.8;">
              <q-item dense class="absolute-bottom text-h5 text-white text-weight-bolder q-ma-sm" style="text-shadow: 2px 2px black;">{{ series.series_title }}
                <q-badge floating transparent color="grey-10" align="bottom">Chosen By: {{ toTitleCase(series.series_chosen_by) }}</q-badge>
              </q-item>
              <q-badge floating transparent color="grey-10" align="top" class="text-h6 text-weight-bold">Rank: {{ series.series_rank + 1 }}</q-badge>
            </q-parallax>
            <q-tabs v-model="tabs" color="primary" align="justify">
              <q-tab flat dense name="overview" label="overview" />
              <q-tab flat dense name="movies" label="movies" />
            </q-tabs>
            <q-separator />
            <q-tab-panels v-model="tabs" animated transition-prev="jump-left" transition-next="jump-right" style="height: 200px; min-width: 350px;">
              <q-tab-panel round horizontal name="overview" class="q-pa-none bg-grey-1">
                <q-card-section round horizontal class="q-mt-sm">
                  <q-icon name="movie" size="md" color=primary class="q-ml-sm col-1" />
                  <q-space />
                  <q-item dense class="text-h6 text-bold">Movies in Series: {{ series.series_movies.length }}</q-item>
                  <q-space />
                  <q-icon name="movie" size="md" color=primary class="q-mr-sm col-1" />
                </q-card-section>
                <q-card-section round horizontal class="q-pa-sm">
                  <q-space />
                  <q-icon name="thumb_up" size="lg" color=primary class="q-ml-xl" />
                  <q-item dense class="text-h4 text-bold">{{ series.series_good_votes }} | {{ series.series_bad_votes }}</q-item>
                  <q-icon name="thumb_down" size="lg" color=primary class="q-mr-xl" />
                  <q-space />
                </q-card-section>
                <q-card-section horizontal round>
                  <q-icon name="star" size="lg" color=primary class="q-mt-md q-ml-sm" />
                  <q-space />
                  <q-item-label class="text-h2 text-bold text-center">{{ parseFloat(series.series_rating).toFixed(2) }}%</q-item-label>
                  <q-space />
                  <q-icon name="star" size="lg" color=primary class="q-mt-md q-mr-sm" />
                </q-card-section>
              </q-tab-panel>
              <q-tab-panel round horizontal name="movies" class="q-pa-none bg-grey-1">
                <q-card-section round horizontal class="q-pt-sm bg-grey-4">
                  <q-item dense class="q-pl-lg col-6">Title</q-item>
                  <q-item dense class="col-2">Dan</q-item>
                  <q-item dense class="col-2">Nick</q-item>
                  <q-item dense class="q-pl-xs col-2">{{ parseFloat(series.series_rating).toFixed(1) }}%</q-item>
                </q-card-section>
                <div v-if="series.series_movies">
                  <q-scroll-area style="height: 200px;">
                    <q-card-section v-for="movie in series.series_movies" :key="movie" class="bg-grey-2">
                      <q-card-section horizontal>
                        <q-item dense class="col-6">{{ movie.movie_title }}</q-item>
                        <q-space />
                        <q-icon dense v-if="movie.dan_vote == 'GOOD'" name="thumb_up" size="sm" color=secondary class="col-2" />
                        <q-icon dense v-else-if="movie.dan_vote == 'BAD'" name="thumb_down" size="sm" color=red class="col-2" />
                        <q-icon dense v-else name="do_not_disturb" size="sm" color=primary class="col-2" />
                        <q-space />
                        <q-icon dense v-if="movie.nick_vote == 'GOOD'" name="thumb_up" size="sm" color=secondary class="col-2" />
                        <q-icon dense v-else-if="movie.nick_vote == 'BAD'" name="thumb_down" size="sm" color=red class="col-2" />
                        <q-icon dense v-else name="do_not_disturb" size="sm" color=primary class="col-2" />
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
              </q-tab-panel>
            </q-tab-panels>
            <q-card-section horizontal>
              <q-badge floating transparent color="grey-10">Series: #{{ series.series_order }}</q-badge>
            </q-card-section>
          </q-card-section>
        </q-card>
      </div>
      <template v-slot:loading>
        <div class="row flex-center q-my-md">
          <q-spinner-dots color="primary" size="40px" />
        </div>
      </template>
    </q-infinite-scroll>
  </q-page>
</template>

<script>
import { defineComponent, ref } from 'vue'
import axios from 'axios'

export default defineComponent({
  name: 'SeriesPage',
  data () {
    return {
      seriess: null,
      timeline: {},
      scrollStop: false
    }
  },
  setup () {
    return {
      tabs: ref('overview'),
      iscroller: ref('iscroller'),
      ttr_toggle: ref('series_order'),
      ad_toggle: ref('descending'),
    }
  },
  async created () {
    const response = await axios.get("http://localhost:1234/timeline")
    this.seriess = response.data
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
    onScroll(index, done) {
      setTimeout(() => {
        const i = index - 1
        const offset = 9
        this.timeline = Object.values(this.timeline).concat(Object.values(this.seriess.slice(i * offset, i * offset + offset)))
        done(i * offset + offset > this.seriess.length)
      }, 2000)
    },
    sortSeries() {
      switch (this.ttr_toggle) {
        case 'series_order':
          if (this.ad_toggle === 'ascending') {
            this.seriess.sort((a, b) => { return a.series_order > b.series_order; })
          } else {
            this.seriess.sort((a, b) => { return a.series_order < b.series_order; })
          }
          break
        case 'series_title':
          if (this.ad_toggle === 'ascending') {
            this.seriess.sort((a, b) => { return a.series_title < b.series_title; })
          } else {
            this.seriess.sort((a, b) => { return a.series_title > b.series_title; })
          }
          break
        case 'movies_in_series':
          if (this.ad_toggle === 'ascending') {
            this.seriess.sort((a, b) => { return a.series_movies.length > b.series_movies.length; })
          } else {
            this.seriess.sort((a, b) => { return a.series_movies.length < b.series_movies.length; })
          }
          break
        case 'series_rank':
          if (this.ad_toggle === 'ascending') {
            this.seriess.sort((a, b) => { return a.series_rank < b.series_rank; })
          } else {
            this.seriess.sort((a, b) => { return a.series_rank > b.series_rank; })
          }
          break
        default:
          console.warn("Invalid sorting options", this.ttr_toggle, this.ad_toggle)
      }
      this.timeline = {}
      this.$refs.iscroller.reset()
      this.$refs.iscroller.resume()
      this.$refs.iscroller.trigger()
    },
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    }
  }
})
</script>
