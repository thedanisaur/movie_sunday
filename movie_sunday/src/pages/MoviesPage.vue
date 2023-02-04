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
          <q-icon v-if="searchText" name="close" @click.stop.prevent="searchText = ''" class="cursor-pointer" />
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
        <q-card v-for="movie in scrollerMovies" :key="movie" bordered class="q-ma-md btn-card">
          <q-card-section horizontal @click="openEditMovieDialog(movie)">
            <q-img
              spinner-color="white"
              width="160px"
              height="140px"
              fit="fill"
              :src="require('../assets/' + movie.movie_image)"
              class="col-1"
            />
            <q-separator vertical size=".125em" color="primary" />
            <q-card-section class="col-6">
              <q-item dense>{{ movie.series_title }}:</q-item>
              <q-item class="text-h4 text-bold">{{ movie.movie_title }}</q-item>
              <q-item dense>{{ movie.movie_created_on }}</q-item>
            </q-card-section>
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
            <q-card-section v-if="movie.movie_trackers && movie.movie_trackers.length > 0">
              <q-chip
                v-for="tracker in movie.movie_trackers"
                :key="tracker"
                square
                color="secondary"
                class="q-ml-md"
                :class="{ 'truncate-chip-labels': true}"
              >
                <q-avatar color="teal-2" :font-size="tracker.tracker_count < 1000 ? '18px' : tracker.tracker_count < 10000 ? '12px' : '10px'" size="md" text-color="black">{{ tracker.tracker_count }}</q-avatar>
                <div class="ellipsis">
                  {{ tracker.tracker_text }}
                  <q-tooltip>{{ tracker.tracker_text }}: {{ tracker.tracker_count }}</q-tooltip>
                </div>
              </q-chip>
            </q-card-section>
            <q-card-section v-else class="col-2">
              <q-chip
                square
                color="secondary"
                class="q-ml-md"
              >
                <q-avatar color="teal-2" size="md" icon="sentiment_very_dissatisfied" text-color="black"></q-avatar>
                <div class="ellipsis">
                  No Trackers
                  <q-tooltip>No Trackers</q-tooltip>
                </div>
              </q-chip>
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
    <q-dialog v-model="addMovieDialog">
      <q-card class="q-pa-md">
        <q-form
          @submit="onSubmitAddMovieDialog"
          @reset="onResetAddMovieDialog"
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
          <q-card-actions>
            <q-btn dense flat color="primary" label="Cancel" @click="onResetAddMovieDialog()" v-close-popup />
            <q-space />
            <q-btn dense flat color="primary" label="Clear" type="reset" class="q-mr-md" />
            <q-btn dense color="primary" label="Submit" type="submit" />
          </q-card-actions>
        </q-form>
      </q-card>
    </q-dialog>
    <q-dialog v-model="editMovieDialog">
      <q-card class="q-pa-md">
        <q-form
          @submit="!this.editMovie.has_vote && this.editMovie.user_vote !== 'NULL' ? confirmVoteDialog = true : onSubmitEditMovieDialog()"
          @reset="onResetEditMovieDialog(false)"
          style="min-width: 500px"
        >
          <q-card-section horizontal class="q-ma-sm">
            <div class="column">
              <q-item-label class="text-h5 text-bold">{{ this.editMovie.movie_title }}</q-item-label>
              <q-item-label caption>Your Vote:</q-item-label>
              <q-card-section horizontal>
                <q-card-section>
                  <q-icon
                    :name="calcThumb(this.editMovie.user_vote).name"
                    :size="calcThumb(this.editMovie.user_vote).size"
                    :color="calcThumb(this.editMovie.user_vote).color"
                    class="q-mt-sm q-ml-xl q-mr-xl q-pa-sm" />
                  </q-card-section>
                <q-separator v-if="!this.editMovie.has_vote" vertical />
                <q-card-section v-if="!this.editMovie.has_vote" class="column">
                  <q-btn flat icon="thumb_up" color="secondary" style="border-style: solid; border-radius: 10px;" @click="updateVote('GOOD')" />
                  <q-separator class="q-ma-xs" />
                  <q-btn flat icon="thumb_down" color="red" style="border-style: solid; border-radius: 10px;" @click="updateVote('BAD')" />
                </q-card-section>
              </q-card-section>
            </div>
            <q-space />
            <q-img
              spinner-color="white"
              width="160px"
              height="140px"
              fit="fill"
              :src="require('../assets/' + this.editMovie.movie_image)"
            />
          </q-card-section>
          <q-item-label caption>Add Trackers</q-item-label>
          <div class="row">
            <q-select
              v-model="selectTrackersModel"
              ref="trackersSelect"
              filled
              multiple
              use-chips
              label="Select Tracker(s)"
              :options="trackers"
              :option-value="opt => Object(opt) === opt && 'tracker_id' in opt ? opt.tracker_id : null"
              :option-label="opt => Object(opt) === opt && 'tracker_text' in opt ? opt.tracker_text : '- Null -'"
              emit-value
              map-options
              style="width: 470px"
            >
              <template v-slot:no-option>
                <q-item>
                  <q-item-section class="text-grey">
                    No results
                  </q-item-section>
                </q-item>
              </template>
            </q-select>
            <q-btn dense color="primary" :disable="selectTrackersModel.length < 1" icon="add" size="md" @click="addTrackerData()" />
          </div>
          <q-scroll-area style="height: 200px;" class="bg-grey-2 q-ma-sm">
            <div v-for="tracker in this.editMovie.movie_trackers" :key="tracker">
              <q-separator />
              <div class="row">
                <q-item-label class="q-mt-md q-ml-md">{{ tracker.tracker_text }} </q-item-label>
                <q-space />
                <q-input
                  dense
                  v-model="tracker.person_tracker_count"
                  outlined
                  required
                  lazy-rules
                  @update:model-value="this.editMovie.modified = true"
                  :rules="[value => !!value && value > 0 || 'Value > 0']"
                  input-class="text-right"
                  style="width: 70px"
                  class="q-ma-sm" />
                <div class="column">
                  <q-btn dense color="primary" icon="add" size='xs' class="q-mt-sm q-mb-xs q-mr-md" @click="tracker.person_tracker_count = tracker.person_tracker_count + 1; this.editMovie.modified = true" />
                  <q-btn dense color="primary" icon="remove" size='xs' class="q-mb-md q-mr-md" @click="tracker.person_tracker_count = tracker.person_tracker_count - 1; this.editMovie.modified = true" />
                </div>
              </div>
            </div>
          </q-scroll-area>
          <q-card-actions>
            <q-btn dense flat color="primary" label="Cancel" @click="onResetEditMovieDialog(true)" v-close-popup />
            <q-space />
            <q-btn dense flat color="primary" label="Clear" type="reset" class="q-mr-md" />
            <q-btn dense color="primary" :disable="!this.editMovie.modified" label="Submit" type="submit" />
          </q-card-actions>
        </q-form>
      </q-card>
    </q-dialog>
    <q-dialog v-model="confirmVoteDialog" persistent>
      <q-card>
        <q-card-section class="items-center">
          <q-item-label class="text-h5 text-bold">Are you sure {{ this.editMovie.movie_title }} is "{{ toTitleCase(this.editMovie.user_vote) }}"?</q-item-label>
          <q-item-label caption>Your vote can not be changed once submitted!</q-item-label>
        </q-card-section>
        <q-card-actions>
          <q-btn dense flat label="Cancel" color="primary" v-close-popup />
          <q-space />
          <q-btn dense label="Submit" color="primary" @click="onSubmitEditMovieDialog()" v-close-popup />
        </q-card-actions>
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
      editMovie: null,
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
    const movie_response = await axios.get('https://localhost:1234/movies')
    movie_response.data.forEach((movie, arr) => {
      movie.movie_image = this.randomImage()
      movie.added_trackers = []
    })
    this.movies = movie_response.data

    const series_response = await axios.get('https://localhost:1234/series')
    this.series = series_response.data
    this.filteredSeries = this.series

    const tracker_response = await axios.get('https://localhost:1234/trackers')
    this.trackers = tracker_response.data
  },
  setup () {
    return {
      series: [],
      trackers: [],
      iscroller: ref('iscroller'),
      smd_toggle: ref('date'),
      ad_toggle: ref('descending'),
      seriesSelect: ref('seriesSelect'),
      trackersSelect: ref('trackersSelect'),
      selectSeriesModel: ref(null),
      selectTrackersModel: ref([]),
      addMovieDialog: ref(false),
      editMovieDialog: ref(false),
      confirmVoteDialog: ref(false),
    }
  },
  methods: {
    addMovieData () {
      const id = this.movieData[this.movieData.length - 1].id + 1
      this.movieData.push({ id: id, movie_title: '' })
    },
    removeMovieData(movie) {
      this.movieData.splice(this.movieData.indexOf(movie), 1)
    },
    addTrackerData () {
      this.selectTrackersModel.forEach((tracker_id) => {
        const tracker = this.trackers.find((tracker) => {
          return tracker.tracker_id === tracker_id
        })
        const movie_tracker = {
          movie_name: this.editMovie.movie_name,
          person_tracker_count: 0,
          tracker_count: 0,
          tracker_id: tracker.tracker_id,
          tracker_text: tracker.tracker_text
        }
        const index = this.editMovie.movie_trackers.findIndex(tracker => tracker.tracker_id === movie_tracker.tracker_id)
        if (index === -1) {
          this.editMovie.movie_trackers.push(movie_tracker)
          this.editMovie.added_trackers.push(tracker_id)
        }
      })
      this.editMovie.modified = true
      this.selectTrackersModel.splice(0)
    },
    updateVote (vote) {
      this.editMovie.user_vote = vote
      this.editMovie.modified = true
    },
    async openEditMovieDialog (movie) {
      const username = sessionStorage.getItem('username')
      this.editMovie = movie
      this.editMovie.modified = false
      // TODO this is stupid
      username === 'dan' ? this.editMovie.user_vote = this.editMovie.dan_vote : this.editMovie.user_vote = this.editMovie.nick_vote
      this.editMovie.has_vote = this.editMovie.user_vote !== 'NULL'
      const movie_name = movie.movie_name
      const response = await axios.get(`https://localhost:1234/movie_trackers/${movie_name}/${username}`)
      if (response.data) {
        response.data.forEach((curr_movie_tracker) => {
          const curr_tracker_id = curr_movie_tracker.tracker_id
          const movie_tracker = this.editMovie.movie_trackers.find((mt) => {
            return mt.tracker_id === curr_tracker_id
          })
          movie_tracker['person_tracker_count'] = curr_movie_tracker.tracker_count
        })
      }
      this.editMovieDialog = true
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
    onResetAddMovieDialog () {
      this.selectSeriesModel = null
      this.movieData.splice(1)
      this.movieData[0].movie_title = ''
    },
    onResetEditMovieDialog (cancel) {
      this.editMovie.modified = false
      this.selectTrackersModel.splice(0)
      if (!this.editMovie.has_vote) {
        // TODO this is still stupid
        username === 'dan' ? this.editMovie.user_vote = this.editMovie.dan_vote : this.editMovie.user_vote = this.editMovie.nick_vote
      }

      // Remove unsubmitted trackers
      this.editMovie.added_trackers.forEach(added_tracker => {
        this.editMovie.movie_trackers = this.editMovie.movie_trackers.filter(tracker => {
          return tracker.tracker_id !== added_tracker
        })
      })

      // Only clear the edit movie if we click cancel
      // editMovieDialog throws a fit because editMovie is null, so stop showing it.
      if (cancel) {
        this.editMovieDialog = false
        this.editMovie = null
      }
    },
    async onSubmitAddMovieDialog () {
      const username = sessionStorage.getItem('username')
      const jwt_token = sessionStorage.getItem('jwt_token')
      const series_name = this.selectSeriesModel
      const movie_json = JSON.stringify(this.movieData)
      axios.post(`https://localhost:1234/movies/${series_name}`, movie_json, {
        headers: {
          'Authorization': `${jwt_token}`,
          'Content-Type': 'application/json',
          'Username': `${username}`,
        },
      }).then(response => {
        console.log(response.data)
        Notify.create({
          type: 'positive',
          timeout: 1000,
          message: 'Movie(s) Added'
        })
      }).catch(error => {
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
    async onSubmitEditMovieDialog () {
      if (!this.editMovie.modified) return
      const jwt_token = sessionStorage.getItem('jwt_token')
      const username = sessionStorage.getItem('username')

      // Add vote
      if (!this.editMovie.has_vote && this.editMovie.user_vote !== 'NULL') {
        const vote_json = JSON.stringify({
          movie_name: this.editMovie.movie_name,
          vote_value: this.editMovie.user_vote,
          person_username: username,
        })
        axios.post(`https://localhost:1234/vote`, vote_json, {
          headers: {
            'Authorization': `${jwt_token}`,
            'Content-Type': 'application/json',
            'Username': `${username}`,
          },
        }).then(response => {
          console.log(response.data)
          Notify.create({
            type: 'positive',
            timeout: 1000,
            message: 'Vote Added'
          })
          // TODO it's getting more stupid
          username === 'dan' ? this.editMovie.dan_vote = this.editMovie.user_vote : this.editMovie.nick_vote = this.editMovie.user_vote
          this.editMovie.has_vote = true
        }).catch(error => {
          if (error.response) {
            Notify.create({
              type: 'negative',
              message: 'Failed: Vote'
            })
            console.log(error.response.data)
          } else {
            console.log(error)
          }
        })
      }

      // Edit movie trackers
      // Reuse tracker_count field for insert/update
      this.editMovie.movie_trackers.forEach(movie_tracker => {
        movie_tracker.tracker_count = parseInt(movie_tracker.person_tracker_count)
      })
      const trackers_json = JSON.stringify(this.editMovie.movie_trackers)
      axios.post(`https://localhost:1234/movie_trackers/${username}`, trackers_json, {
        headers: {
          'Authorization': `${jwt_token}`,
          'Content-Type': 'application/json',
          'Username': `${username}`,
        },
      }).then(response => {
        this.editMovie.added_trackers = []
        if (response.data.inserts > 0 || response.data.updates > 0) {
          console.log(response.data)
          Notify.create({
            type: 'positive',
            timeout: 1000,
            message: 'Movie Tracker(s) Added/Updated'
          })
        }
      }).catch(error => {
        if (error.response) {
          Notify.create({
            type: 'negative',
            message: 'Failed: Movie Tracker(s)'
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
    calcThumb(vote) {
      if (vote === "GOOD") {
        return {
          name: "thumb_up",
          size: "64px",
          color: "secondary"
        }
      } else if (vote === "BAD") {
        return {
          name: "thumb_down",
          size: "64px",
          color: "red"
        }
      } else {
        return {
          name: "do_not_disturb",
          size: "64px",
          color: "primary"
        }
      }
    },
    randomImage () {
      const images = [
          'module-6.jpg',
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
.truncate-chip-labels {
  max-width: 200px
}
</style>

