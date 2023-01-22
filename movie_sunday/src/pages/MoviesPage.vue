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
        />
      <q-space />
      <q-input
        v-model="searchText"
        filled
        label="Search"
      >
        <template v-slot:append>
          <q-icon name="search" />
        </template>
      </q-input>
      <q-btn-toggle
        v-model="sm_toggle"
        size="md"
        title="Sort by Series/Movie"
        @click="sortMovies()"
        text-color="primary"
        :options="[
          { slot: 'series', value: 'series'},
          { slot: 'movie', value: 'movie'},
        ]"
        class="q-ma-sm"
      >
        <template v-slot:series>
          <q-icon name="camera" />
        </template>
        <template v-slot:movie>
          <q-icon name="movie" />
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
      <q-button glossy ripple v-for="movie in scrollerMovies" :key="movie" @click="onClick(movie.movie_name)">
        <q-card bordered class="q-ma-md btn-card">
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
            <q-card-section class="col-2">
              <q-chip v-for="tracker in movie.movie_trackers" :key="tracker" square color="secondary" class="q-ml-md">{{ tracker.tracker_text }}: {{ tracker.tracker_count }}</q-chip>
            </q-card-section>
          </q-card-section>
        </q-card>
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
      </q-button>
      <template v-slot:loading>
        <div class="row flex-center q-my-md">
          <q-spinner-dots color="primary" size="40px" />
        </div>
      </template>
    </q-infinite-scroll>
    <q-item-label v-else-if="this.searchText" class="text-h3 text-bold row">No results for {{ this.searchText }}</q-item-label>
    </div>
  </q-page>
</template>

<script>
import { defineComponent, ref } from 'vue'
import axios from 'axios'

export default defineComponent({
  name: 'MoviesPage',
  data () {
    return {
      movies: null,
      scrollerMovies: {},
      searchText: ref(''),
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
    filteredMovies(n, old) {
      if (old.length != 0) {
        this.scrollerMovies = {}
        this.$refs.iscroller.reset()
        this.$refs.iscroller.resume()
        this.$refs.iscroller.trigger()
      }
    }
  },
  async created () {
    const response = await axios.get('http://localhost:1234/movies')
    response.data.forEach((item, arr) => {
      item.movie_image = this.randomImage()
    })
    this.movies = response.data
  },
  setup () {
    return {
      iscroller: ref('iscroller'),
      sm_toggle: ref('movie'),
      ad_toggle: ref('descending'),
    }
  },
  methods: {
    onClick(movie_name) {
      console.log(movie_name)
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
      switch (this.sm_toggle) {
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
        default:
          console.warn("Invalid sorting options", this.sm_toggle, this.ad_toggle)
      }
      this.scrollerMovies = {}
      this.$refs.iscroller.reset()
      this.$refs.iscroller.resume()
      this.$refs.iscroller.trigger()
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
