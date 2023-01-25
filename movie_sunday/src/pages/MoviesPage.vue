<template>
  <q-page class="flex">
    <q-toolbar class="absolute-top bg-grey-2">
      <q-btn
          v-if="isLoggedIn"
          size="md"
          color="primary"
          icon="add"
          title="Add Movie"
          label="Add Movie"
          @click="addMovieDialog = true"
        />
      <q-space />
      <q-input
        v-model="searchText"
        filled
        dense
        label="Search"
      >
        <template v-slot:append>
          <q-icon name="search" />
        </template>
      </q-input>
      <q-btn-toggle
        v-model="smd_toggle"
        size="md"
        title="Sort by Series/Movie/Date Added"
        @click="sortMovies()"
        text-color="primary"
        :options="[
          { slot: 'series', value: 'series'},
          { slot: 'movie', value: 'movie'},
          { slot: 'date', value: 'date'},
        ]"
        class="q-ma-sm"
      >
        <template v-slot:series>
          <q-icon name="camera" />
        </template>
        <template v-slot:movie>
          <q-icon name="movie" />
        </template>
        <template v-slot:date>
          <q-icon name="calendar_month" />
        </template>
      </q-btn-toggle>
      <q-btn-toggle
        v-model="ad_toggle"
        size="md"
        title="Sort Ascending/Descending"
        @click="sortMovies()"
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
    <div class="q-pa-md q-mt-xl" style="min-width: 100%">
      <q-infinite-scroll v-if="filteredMovies.length > 0" ref="iscroller" @load="onScroll" style="min-width: 100%">
        <q-card v-for="movie in scrollerMovies" :key="movie" @click="onClick(movie.movie_name)" bordered class="q-ma-md btn-card">
          <q-card-section horizontal>
            <q-img
              spinner-color="white"
              width="160px"
              height="140px"
              fit="fill"
              :src="require('../assets/' + movie.movie_image)"
            />
            <q-separator vertical size=".125em" color="primary" />
            <q-card-section class="col-6">
              <q-item dense>{{ movie.series_title }}:</q-item>
              <q-item class="text-h4 text-bold">{{ movie.movie_title }}</q-item>
              <q-item dense>{{ movie.movie_created_on }}</q-item>
            </q-card-section>
            <q-space />
            <q-card-section horizontal class="col-2">
              <q-separator vertical inset color="primary" />
              <q-card-section>
                <q-item-label>Dan Vote:</q-item-label>
                <q-icon dense v-if="movie.dan_vote == 'GOOD'" name="thumb_up" size="xl" color=secondary class="q-ma-sm q-pa-sm"/>
                <q-icon dense v-else-if="movie.dan_vote == 'BAD'" name="thumb_down" size="xl" color=red class="q-ma-sm q-pa-sm"/>
                <q-icon dense v-else name="do_not_disturb" size="xl" color=primary class="q-ma-sm q-pa-sm"/>
              </q-card-section>
              <q-separator vertical inset color="primary" />
              <q-card-section>
                <q-item-label>Nick Vote:</q-item-label>
                <q-icon dense v-if="movie.nick_vote == 'GOOD'" name="thumb_up" size="xl" color=secondary class="q-ma-sm q-pa-sm"/>
                <q-icon dense v-else-if="movie.nick_vote == 'BAD'" name="thumb_down" size="xl" color=red class="q-ma-sm q-pa-sm"/>
                <q-icon dense v-else name="do_not_disturb" size="xl" color=primary class="q-ma-sm q-pa-sm"/>
              </q-card-section>
              <q-separator vertical inset color="primary" />
            </q-card-section>
            <q-card-section v-if="movie.movie_trackers && movie.movie_trackers.length > 0" class="col-2">
              <q-chip v-for="tracker in movie.movie_trackers" :key="tracker" square color="secondary" class="q-ml-md">{{ tracker.tracker_text }}: {{ tracker.tracker_count }}</q-chip>
            </q-card-section>
            <q-card-section v-else class="col-2">
              <q-chip square color="secondary" text-color="black" icon-right="sentiment_very_dissatisfied" label="No Trackers" class="q-ml-md" />
            </q-card-section>
          </q-card-section>
          <q-tooltip
            anchor="bottom middle"
            self="bottom middle"
            :delay="1000"
            transition-show="scale"
            transition-hide="scale"
            :offset="[14, 14]"
            class="bg-primary text-body2 shadow-4"
          >
            Edit: {{ movie.movie_title }}
          </q-tooltip>
        </q-card>
        <template v-slot:loading>
          <div class="row flex-center q-my-md">
            <q-spinner-dots color="primary" size="40px" />
          </div>
        </template>
      </q-infinite-scroll>
      <q-item-label v-else-if="this.searchText" class="text-h3 text-bold row">No results for {{ this.searchText }}</q-item-label>
    </div>
    <!-- DIALOGS -->
    <!-- TODO no-backdrop-dismiss fixes a bug on my dev machine -->
    <q-dialog no-backdrop-dismiss v-model="addMovieDialog">
      <q-card class="q-pa-md">
        <q-form
          @submit="onSubmit"
          @reset="onReset"
          class="q-gutter-md"
          style="min-width: 500px"
        >
          <q-select
            v-model="selectSeriesModel"
            ref="seriesSelect"
            filled
            clearable
            use-input
            hide-selected
            required
            fill-input
            autocomplete="series_name"
            label="Select Series"
            :options="filteredSeries"
            :option-value="opt => Object(opt) === opt && 'series_name' in opt ? opt.series_name : null"
            :option-label="opt => Object(opt) === opt && 'series_title' in opt ? opt.series_title : '- Null -'"
            emit-value
            map-options
            @filter="filterSeries"
            style="width: 250px; padding-bottom: 32px"
          >
            <template v-slot:no-option>
              <q-item>
                <q-item-section class="text-grey">
                  No results
                </q-item-section>
              </q-item>
            </template>
          </q-select>
          <div class="row">
            <q-item-label>Add Movies</q-item-label>
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

export default defineComponent({
  name: 'MoviesPage',
  data () {
    return {
      movies: null,
      scrollerMovies: {},
      filteredSeries: [],
      searchText: ref(''),
      movieData: [ { id: 0, movie_title: '' } ],
      isLoggedIn: sessionStorage.getItem('username') !== null,
    }
  },
  computed: {
    filteredMovies () {
      if (this.movies) {
        return this.movies.filter((movie) => movie.movie_title.toLowerCase().includes(this.searchText.toLowerCase()) || movie.series_title.toLowerCase().includes(this.searchText.toLowerCase()));
      } else {
        return []
      }
    },
  },
  watch: {
    filteredMovies(newList, oldList) {
      if (oldList.length != 0) {
        this.scrollerMovies = {}
        this.$refs.iscroller.reset()
        this.$refs.iscroller.resume()
        this.$refs.iscroller.trigger()
      }
    }
  },
  async created () {
    const movie_response = await axios.get('http://localhost:1234/movies')
    movie_response.data.forEach((item, arr) => {
      item.movie_image = this.randomImage()
    })
    this.movies = movie_response.data

    const series_response = await axios.get('http://localhost:1234/series')
    this.series = series_response.data
    this.filteredSeries = this.series
  },
  setup () {
    return {
      series: [],
      iscroller: ref('iscroller'),
      smd_toggle: ref('movie'),
      ad_toggle: ref('descending'),
      seriesSelect: ref('seriesSelect'),
      selectSeriesModel: ref(null),
      addMovieDialog: ref(false),
    }
  },
  methods: {
    addMovieData() {
      const id = this.movieData[this.movieData.length - 1].id + 1
      this.movieData.push({ id: id, movie_title: '' })
    },
    removeMovieData(movie) {
      this.movieData.splice(this.movieData.indexOf(movie), 1)
    },
    onClick(movie_name) {
      console.log(movie_name)
    },
    filterSeries (value, update, abort) {
      if (value === '') {
        update(() => {
          this.filteredSeries = this.series
        })
        return
      }
      update(() => {
        const needle = value.toLowerCase()
        this.filteredSeries = this.series.filter(series => series.series_title.toLowerCase().indexOf(needle) > -1)
      })
      const seriesSelect = this.$refs.seriesSelect
      if (value !== '' && seriesSelect.options.length === 1) {
        seriesSelect.setOptionIndex(-1) // reset optionIndex in case there is something selected
        seriesSelect.moveOptionSelection(1) // focus the first selectable option and do not update the input-value
        seriesSelect.add(seriesSelect.options[seriesSelect.getOptionIndex()])
      }
    },
    onReset () {
      this.selectSeriesModel = null
      this.movieData.splice(1)
      this.movieData[0].movie_title = ''
    },
    async onSubmit () {
      const jwt_token = sessionStorage.getItem('jwt_token')
      const series_name = this.selectSeriesModel
      const movie_json = JSON.stringify(this.movieData)
      axios.post(`http://localhost:1234/movies/${series_name}`, movie_json, {
        headers: {
          'Authorization': `Bearer ${jwt_token}`,
          'Content-Type': 'application/json'
        },
      }).then(function(response) {
        console.log(response.data)
        Notify.create({
          type: 'positive',
          message: 'Movie(s) Added'
        })
      }).catch(function(error) {
        if (error.response) {
          Notify.create({
            type: 'negative',
            message: error.response.data
          })
          console.log(error.response.data)
        } else {
          console.log(error)
        }
      })
    },
    onScroll(index, done) {
      setTimeout(() => {
        const i = index - 1
        const offset = 5
        const startValue = i * offset
        const endValue = i * offset + offset
        this.scrollerMovies = Object.values(this.scrollerMovies).concat(Object.values(this.filteredMovies.slice(startValue, endValue)))
        done(endValue > this.filteredMovies.length)
      }, 100)
    },
    randomImage () {
      const images = [
          'module-6.jpg',
          'i8148hnowoo91.jpg',
          'mb34g6daf4h91.jpg',
          'nw0prizii5x91.jpg',
        ]
      const image = images[Math.floor(Math.random() * images.length)]
      return image
    },
    sortMovies () {
      switch (this.smd_toggle) {
        case 'series':
          if (this.ad_toggle === 'ascending') {
            this.movies.sort((a, b) => { return a.series_title < b.series_title; })
          } else {
            this.movies.sort((a, b) => { return a.series_title > b.series_title; })
          }
          break
        case 'movie':
          if (this.ad_toggle === 'ascending') {
            this.movies.sort((a, b) => { return a.movie_title < b.movie_title; })
          } else {
            this.movies.sort((a, b) => { return a.movie_title > b.movie_title; })
          }
          break
        case 'date':
          if (this.ad_toggle === 'ascending') {
            this.movies.sort((a, b) => { return a.movie_created_on > b.movie_created_on; })
          } else {
            this.movies.sort((a, b) => { return a.movie_created_on < b.movie_created_on; })
          }
          break
        default:
          console.warn("Invalid sorting options", this.smd_toggle, this.ad_toggle)
      }
      if (this.scrollerMovies.length >= this.movies.length) {
        this.$refs.iscroller.reset()
        this.$refs.iscroller.resume()
        this.$refs.iscroller.trigger()
      }
      this.scrollerMovies = {}
    },
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    },
  }
})
</script>
<style lang="scss" scoped>
.btn-card:hover {
  box-shadow: 0px 0px 10px 2px $primary;
}
</style>
