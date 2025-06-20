<template>
  <q-page class="flex flex-center">
    <q-toolbar :class="'absolute-top ' + bgColor()">
      <q-btn
          v-if="isLoggedIn"
          size="md"
          color="primary"
          icon="add"
          @click="addTrackerDialog = true"
          title="Add Tracker"
          label="Add Tracker"
        />
      <q-space />
      <q-btn-toggle
        v-model="pua_toggle"
        size="md"
        title="Sort by Popularity/Last Updated/Alphabetical"
        @click="sortTrackers()"
        text-color="primary"
        :options="[
          { slot: 'rank', value: 'tracker_rank'},
          { slot: 'time', value: 'tracker_created_on'},
          { slot: 'text', value: 'tracker_text'},
        ]"
        class="q-ma-sm"
      >
        <template v-slot:rank>
          <q-icon name="hotel_class" />
        </template>
        <template v-slot:time>
          <q-icon name="history" />
        </template>
        <template v-slot:text>
          <q-icon name="list" />
        </template>
      </q-btn-toggle>
      <q-btn-toggle
        v-model="ad_toggle"
        size="md"
        title="Sort Ascending/Descending"
        @click="sortTrackers()"
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
    <div class="q-pa-md q-mt-xl q-gutter-md row flex-center">
      <q-card v-for="tracker in trackers" :key="tracker" bordered style="min-width: 300px; max-width: 350px" class="btn-card">
        <q-card-section @click="openMovieListDialog(tracker)">
          <!-- HEADER -->
          <q-img :src=tracker.tracker_image height="100" style="opacity: 0.8;">
            <q-item class="q-pa-sm">
              <q-item-section>
                <q-avatar color="primary" size="64px" :font-size="tracker.tracker_count < 1000 ? '32px' : tracker.tracker_count < 10000 ? '26px' : '22px'" class="text-h2 text-white text-weight-bold">
                  {{ tracker.tracker_count }}
                </q-avatar>
              </q-item-section>
              <q-item-section>
                <q-item-label dense class="text-h5 text-white text-weight-bolder text-right" style="text-shadow: 2px 2px black;">
                  {{ tracker.tracker_text }}
                </q-item-label>
              </q-item-section>
            </q-item>
          </q-img>
          <!-- BODY -->
          <!-- FOOTER -->
          <q-chip icon="add_circle_outline">{{ toTitleCase(tracker.tracker_created_by) }}</q-chip>
          <q-chip icon="calendar_today">{{ tracker.tracker_created_on }}</q-chip>
          <q-separator />
        </q-card-section>
      </q-card>
    </div>
    <!-- DIALOGS -->
    <q-dialog v-model="addTrackerDialog">
      <q-card class="q-pa-md">
        <q-form
          @submit="onSubmit"
          @reset="onReset"
          class="q-gutter-md"
          style="min-width: 400px"
        >
          <div class="row">
            <q-item-label>Add Tracker</q-item-label>
          </div>
          <q-input
            v-model="inputTrackerText"
            filled
            label="Tracker"
            required
            hint="Tracker text that will be displayed on the tracker screen"
          />
          <div class="row">
            <q-btn dense flat color="primary" label="Cancel" v-close-popup />
            <q-space />
            <q-btn dense flat color="primary" label="Clear" type="reset" class="q-mr-md" />
            <q-btn dense color="primary" label="Submit" type="submit" />
          </div>
        </q-form>
      </q-card>
    </q-dialog>
    <q-dialog v-model="movieListDialog">
      <q-card class="q-pa-md" style="min-width: 500px;">
        <div class="flex justify-between">
          <div class="column">
            <q-item class="text-h5 q-pa-none"> {{ currentTracker.tracker_text }}: </q-item>
            <q-avatar color="primary" size="128px" class="text-h2 text-white text-weight-bold q-ml-xl q-mb-md"> {{ currentTracker.tracker_count }} </q-avatar>
          </div>
          <q-card-section class="flex justify-between column q-pa-none">
            <q-img spinner-color="white" width="120px" height="180px" fit="fill" class="absolute" :style="{ filter: 'blur(5px) brightness(0.1)' }" :src=this.currentTracker.tracker_image />
            <q-img spinner-color="white" width="120px" height="180px" fit="fill" :src=this.currentTracker.tracker_image />
          </q-card-section>
        </div>
        <q-item-label caption :class="textColor()">Movies</q-item-label>
        <q-separator size="2px" color="dark" />
        <q-card-section class="q-pa-none bg-grey-1">
          <q-card-section round horizontal class="q-pt-sm bg-primary">
            <q-item dense class="text-white text-bold">Movie Title</q-item>
            <q-space />
            <q-item dense class="text-white text-bold">Event Count</q-item>
          </q-card-section>
          <div v-if="trackerData && trackerData.length > 0">
            <q-scroll-area style="height: 240px;" :class="bgColorMovieRow()">
              <q-card-section v-for="data in trackerData" :key="data" class="q-pa-none">
                <q-btn flat dense outline class="full-width" @click="movieRowClick(data.movie_title)">
                  <q-item class="text-capitalize">{{ data.movie_title }}</q-item>
                  <q-space />
                  <q-item>{{ data.tracker_count }}</q-item>
                </q-btn>
                <q-separator />
              </q-card-section>
            </q-scroll-area>
          </div>
          <div v-else>
            <q-card-section class="bg-grey-2">
              <q-card-section horizontal>
                <q-item class="text-h6 text-bold">No movies currently use this tracker. (^-^*)</q-item>
              </q-card-section>
            </q-card-section>
          </div>
        </q-card-section>
        <q-separator />
        <q-card-actions>
          <q-space />
          <q-btn dense flat color="primary" label="Close" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>
<script>
import { ref, defineComponent } from 'vue'
import axios from 'axios'
import { Notify } from 'quasar'
import cfg from '../../movie_sunday.config.json'

export default defineComponent({
  name: 'TrackerPage',
  data () {
    return {
      trackers: null,
      currentTracker: null,
      trackerData: null,
      isLoggedIn: sessionStorage.getItem('username') !== null
    }
  },
  setup () {
    return {
      addTrackerDialog: ref(false),
      movieListDialog: ref(false),
      inputTrackerText: ref(''),
      pua_toggle: ref('tracker_rank'),
      ad_toggle: ref('descending'),
      tabs: ref('movies'),
    }
  },
  async created () {
    const host = cfg.service.movie.host
    const port = cfg.service.movie.port
    const trackers = cfg.service.movie.trackers
    const response = await axios.get(`${host}:${port}${trackers}`)
    response.data.forEach(async (tracker, arr) => {
      if (!tracker.tracker_image) {
        tracker.tracker_image = `img/missing.jpg`
      }
    })
    this.trackers = response.data
  },
  methods: {
    movieRowClick(movie_title) {
      this.$nextTick(() => {
        this.$router.push({
          path: '/movies',
          query: { searchText: movie_title, strictSeriesTitle: false },
        })
      })
    },
    onReset () {
      this.inputTrackerText = ''
    },
    onSubmit () {
      const username = sessionStorage.getItem('username')
      const jwt_token = sessionStorage.getItem('jwt_token')
      const tracker_json = JSON.stringify({
        'tracker_text': this.inputTrackerText,
        'tracker_created_by': username
      })
      const host = cfg.service.movie.host
      const port = cfg.service.movie.port
      const trackers = cfg.service.movie.trackers
      axios.post(`${host}:${port}${trackers}`, tracker_json, {
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
          message: 'Tracker Added'
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
    async openMovieListDialog (tracker) {
      const tracker_id = tracker.tracker_id
      const host = cfg.service.movie.host
      const port = cfg.service.movie.port
      const movie_trackers = cfg.service.movie.movie_trackers
      const response = await axios.get(`${host}:${port}${movie_trackers}/${tracker_id}`)
      this.trackerData = response.data
      this.currentTracker = tracker
      this.movieListDialog = true
    },
    sortTrackers() {
      switch (this.pua_toggle) {
        case 'tracker_rank':
          if (this.ad_toggle === 'ascending') {
            this.trackers.sort((a, b) => { return a.tracker_rank < b.tracker_rank; })
          } else {
            this.trackers.sort((a, b) => { return a.tracker_rank > b.tracker_rank; })
          }
          break
        case 'tracker_text':
          if (this.ad_toggle === 'ascending') {
            this.trackers.sort((a, b) => { return a.tracker_text < b.tracker_text; })
          } else {
            this.trackers.sort((a, b) => { return a.tracker_text > b.tracker_text; })
          }
          break
        case 'tracker_created_on':
          if (this.ad_toggle === 'ascending') {
            this.trackers.sort((a, b) => { return a.tracker_created_on > b.tracker_created_on; })
          } else {
            this.trackers.sort((a, b) => { return a.tracker_created_on < b.tracker_created_on; })
          }
          break
        default:
          console.warn("Invalid sorting options", this.pua_toggle, this.ad_toggle)
      }
    },
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    },
    textColor () {
      if (this.$q.dark.isActive) {
        return "text-grey"
      }
    },
    bgColor () {
      if (this.$q.dark.isActive) {
        return "bg-grey-10"
      } else {
        return "bg-grey-2"
      }
    },
    bgColorMovieRow () {
      if (this.$q.dark.isActive) {
        return "bg-grey-8"
      } else {
        return "bg-grey-2"
      }
    },
  },
})
</script>
<style lang="scss" scoped>
.btn-card:hover {
  box-shadow: 0px 0px 10px 2px $primary;
}
.q-img .q-img__content .q-item {
  position: static;
}
.blurred-ticket {
  overflow: hidden;
}
.blurred-ticket::before {
  background-image: url('img/ticket.jpg');
  background-size: 50px 25px;
  background-repeat: repeat;
  background-position: center;
  filter: blur(5px);
  z-index: -1;
}
</style>
