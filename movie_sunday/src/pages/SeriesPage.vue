<template>
  <q-page class="flex flex-center row">
    <q-toolbar class="absolute-top bg-grey-2">
      <q-btn
          v-if="isLoggedIn"
          size="md"
          color="primary"
          icon="add"
          @click="addSeriesDialog = true"
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
                <div v-if="series.series_movies && series.series_movies.length > 0">
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
    <!-- DIALOGS -->
    <q-dialog v-model="addSeriesDialog">
      <q-card class="q-pa-md">
        <q-form
          @submit="onSubmit"
          @reset="onReset"
          class="q-gutter-md"
          style="min-width: 500px"
        >
          <div class="row">
            <q-item-label header>Add Series</q-item-label>
          </div>
          <q-input
            v-model="inputSeriesTitle"
            filled
            label="Series"
            required
          />
          <div class="row">
            <q-item-label header >Add Movies</q-item-label>
            <q-space />
            <q-btn color="primary" icon="add" @click="addMovieData()" class="q-mr-xs"/>
          </div>
          <q-scroll-area class="bg-grey-2" style="height: 200px;">
            <div v-for="movie in movieData" :key="movie.id">
              <q-separator />
              <q-input
                dense
                v-model="movie.movie_title"
                filled
                required
                label="Title"
                class="q-ma-sm"
              >
                <template v-slot:append>
                  <q-btn v-if="movieData.length > 1" dense color="primary" icon="remove" @click="removeMovieData(movie)" />
                </template>
              </q-input>
            </div>
          </q-scroll-area>
          <div class="row">
            <q-btn dense flat color="primary" label="Cancel" @click="onReset()" v-close-popup />
            <q-space />
            <q-btn dense flat color="primary" label="Clear" type="reset" class="q-mr-md" />
            <q-btn dense color="primary" label="Submit" type="submit" />
          </div>
        </q-form>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script>
import { defineComponent, ref } from 'vue'
import axios from 'axios'
import { Notify } from 'quasar'
import cfg from '../../ms.config.json'

export default defineComponent({
  name: 'SeriesPage',
  data () {
    return {
      series: null,
      timeline: {},
      scrollStop: false,
      movieData: [ { id: 0, movie_title: '' } ],
      isLoggedIn: sessionStorage.getItem('username') !== null
    }
  },
  setup () {
    return {
      tabs: ref('overview'),
      iscroller: ref('iscroller'),
      ttr_toggle: ref('series_order'),
      ad_toggle: ref('descending'),
      addSeriesDialog: ref(false),
      inputSeriesTitle: ref(''),
    }
  },
  async created () {
    const host = cfg.service.movie.host
    const port = cfg.service.movie.port
    const timeline = cfg.service.movie.timeline
    const response = await axios.get(`https://${host}:${port}${timeline}`)
    this.series = response.data
  },
  methods: {
    addMovieData() {
      const id = this.movieData[this.movieData.length - 1].id + 1
      this.movieData.push({ id: id, movie_title: '' })
    },
    removeMovieData(movie) {
      this.movieData.splice(this.movieData.indexOf(movie), 1)
    },
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
    onReset () {
      this.inputSeriesTitle = ''
      this.movieData.splice(1)
      this.movieData[0].movie_title = ''
    },
    async onSubmit () {
      const username = sessionStorage.getItem('username')
      const jwt_token = sessionStorage.getItem('jwt_token')
      const series_title = this.inputSeriesTitle
      const series_json = JSON.stringify(
        {
          "series_title": series_title,
          "series_chosen_by": username
        }
      )
      const movie_json = JSON.stringify(this.movieData)
      const host = cfg.service.movie.host
      const port = cfg.service.movie.port
      const series = cfg.service.movie.series
      const response = await axios.post(`https://${host}:${port}${series}`, series_json, {
        headers: {
          'Authorization': `${jwt_token}`,
          'Content-Type': 'application/json',
          'Username': `${username}`,
        },
      }).then(series_response => {
        const series_name = series_response.data.series_name
        const host = cfg.service.movie.host
        const port = cfg.service.movie.port
        const movies = cfg.service.movie.movies
        const response = axios.post(`https://${host}:${port}${movies}/${series_name}`, movie_json, {
          headers: {
            'Authorization': `${jwt_token}`,
            'Content-Type': 'application/json',
            'Username': `${username}`,
          },
        }).then(movies_response => {
          console.log(movies_response.data)
          Notify.create({
            type: 'positive',
            timeout: 1000,
            message: 'Movies Added'
          })
        }).catch(movie_error => {
          if (movie_error.response) {
            Notify.create({
              type: 'negative',
              message: movie_error.response.data
            })
            console.log(movie_error.response.data)
          } else {
            console.log(movie_error)
          }
        })
        console.log(series_response.data)
        Notify.create({
          type: 'positive',
          timeout: 1000,
          message: 'Series Added'
        })
      }).catch(series_error => {
        if (series_error.response) {
          Notify.create({
            type: 'negative',
            message: series_error.response.data
          })
          console.log(series_error.response.data)
        } else {
          console.log(series_error)
        }
      })
    },
    onScroll(index, done) {
      setTimeout(() => {
        const i = index - 1
        const offset = 9
        if (this.series) {
          this.timeline = Object.values(this.timeline).concat(Object.values(this.series.slice(i * offset, i * offset + offset)))
          done(i * offset + offset > this.series.length)
        }
      }, 100)
    },
    sortSeries() {
      switch (this.ttr_toggle) {
        case 'series_order':
          if (this.ad_toggle === 'ascending') {
            this.series.sort((a, b) => { return a.series_order > b.series_order; })
          } else {
            this.series.sort((a, b) => { return a.series_order < b.series_order; })
          }
          break
        case 'series_title':
          if (this.ad_toggle === 'ascending') {
            this.series.sort((a, b) => { return a.series_title < b.series_title; })
          } else {
            this.series.sort((a, b) => { return a.series_title > b.series_title; })
          }
          break
        case 'movies_in_series':
          if (this.ad_toggle === 'ascending') {
            this.series.sort((a, b) => { return a.series_movies.length > b.series_movies.length; })
          } else {
            this.series.sort((a, b) => { return a.series_movies.length < b.series_movies.length; })
          }
          break
        case 'series_rank':
          if (this.ad_toggle === 'ascending') {
            this.series.sort((a, b) => { return a.series_rank < b.series_rank; })
          } else {
            this.series.sort((a, b) => { return a.series_rank > b.series_rank; })
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
