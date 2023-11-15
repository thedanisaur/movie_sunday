<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated>
      <q-toolbar>
        <q-btn
          flat
          dense
          size="lg"
          to="/"
          icon="theaters"
          aria-label="Timeline"
          title="Movie Sunday"
          label="Movie Sunday"
          class="q-mr-md col-2"
        />
        <q-tabs no-caps align="justify" class="col-8">
          <q-route-tab
            flat
            dense
            size="lg"
            to="/series"
            title="Series"
            label="Series"
          />
          <q-route-tab
            flat
            dense
            size="lg"
            to="/movies"
            title="Movies"
            label="Movies"
          />
          <q-route-tab
            flat
            dense
            size="lg"
            to="/trackers"
            title="Trackers"
            label="Trackers"
          />
        </q-tabs>
        <q-space />
        <div>
          <q-btn v-if="isLoggedIn" flat icon="account_circle" padding="none" size="lg">
            <q-menu>
              <div class="row no-wrap q-pa-md">
                <div class="column" style="min-width: 150px;">
                  <div class="text-h6 q-mb-none">Settings</div>
                  <q-item-label caption class="q-mb-md">v{{ $q.version }}&nbsp;-&nbsp;v0.1.0</q-item-label>
                  <div class="q-mb-none">UI Mode: </div>
                  <q-toggle v-model="darkMode" toggle-indeterminate @click="toggleDarkMode(darkMode)" :label="darkModeToggleLabel()" />
                </div>
                <q-separator vertical inset class="q-mx-lg" />
                <div class="column items-center" style="min-width: 130px;">
                  <q-avatar size="72px"><img :src="require('../assets/default_image2.jpg')"></q-avatar>
                  <div class="text-bold text-h6 q-mt-xs q-mb-md">{{username}}</div>
                  <q-btn color="primary" flat label="Logout&nbsp;" icon-right="logout" @click="logout()" :to="'/'" v-close-popup />
                </div>
              </div>
            </q-menu>
          </q-btn>
          <q-btn v-else flat icon-right="login" label="Login" :to="'/login'" />
        </div>
      </q-toolbar>
    </q-header>
    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent, ref } from 'vue'
import axios from 'axios'
import { Notify } from 'quasar'
import cfg from '../../movie_sunday.config.json'

export default defineComponent({
  name: 'MainLayout',

  components: {
  },
  data () {
    return {
      darkMode: ref(this.$q.dark.mode),
      isLoggedIn: sessionStorage.getItem('username') !== null,
      loginVerificationInterval: setInterval(() => {
        this.isLoggedIn = sessionStorage.getItem('username') !== null
      }, 1000),
      refreshLoginInterval: setInterval(async () => {
        if (!this.isLoggedIn) return
        const username = sessionStorage.getItem('username')
        const jwt_token = sessionStorage.getItem('jwt_token')
        const host = cfg.service.user.host
        const port = cfg.service.user.port
        const refresh = cfg.service.user.refresh
        const response = await axios.post(`${host}:${port}${refresh}/${username}`, {}, {
          headers: {
            'Authorization': `${jwt_token}`,
            'Username': `${username}`
          },
        }).then(response => {
          Notify.create({
            type: 'positive',
            timeout: 1000,
            message: 'Refreshed Token'
          })
          sessionStorage.setItem('username', response.data.username)
          sessionStorage.setItem('jwt_token', response.data.token)
        }).catch(error => {
          this.logout()
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
      }, 100000), // 100000 is just under 2 min
      fetchImageInterval: setInterval(async () => {
        const username = sessionStorage.getItem('username')
        const jwt_token = sessionStorage.getItem('jwt_token')
        const host = cfg.service.movie.host
        const port = cfg.service.movie.port
        const movies = cfg.service.movie.movies
        const movie_response = await axios.get(`${host}:${port}${movies}`)
        movie_response.data.reduce(async (a, movie) => {
          // All this does is wait for the previous movie to finish
          await a;
          // If the previous movie was found try looking for this image
          const img_host = cfg.service.image.host
          const img_port = cfg.service.image.port
          const images = cfg.service.image.images
          const image_response = await axios.get(`${img_host}:${img_port}${images}/${movie.movie_name}`).catch( error => {
            const image_json = JSON.stringify({
              "movie_title": movie.movie_title,
              "movie_name": movie.movie_name,
              "series_name": movie.series_name
            })
            console.log(`fetching: ${movie.movie_name}`)
            axios.post(`${img_host}:${img_port}${images}`, image_json, {
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
                message: 'Image Fetched!'
              })
            }).catch(error => {
              if (error.response) {
                Notify.create({
                  type: 'negative',
                  message: 'Failed to fetch image'
                })
                console.log(error.response.data)
              } else {
                console.log(error)
              }
            })
            return Promise.reject(new Error('fetched'))
          })
        }, Promise.resolve()).catch(error => {
          if (error !== 'fetched') {
            return
          } else {
            console.log(error)
          }
        })
      }, 30_000), // 1_800_000 = Every 30 minutes
    }
  },
  computed: {
    username () {
      return sessionStorage.getItem('username')
    },
  },
  setup () {
    return {

    }
  },
  methods: {
    darkModeToggleLabel () {
      if (this.$q.dark.mode === "auto") {
        return "Auto"
      } else if (this.$q.dark.mode === false) {
        return "Light"
      } else if (this.$q.dark.mode === true) {
        return "Dark"
      }
    },
    async logout () {
      const username = sessionStorage.getItem('username')
      const jwt_token = sessionStorage.getItem('jwt_token')
      const host = cfg.service.user.host
      const port = cfg.service.user.port
      const logout = cfg.service.user.logout
      const response = await axios.post(`${host}:${port}${logout}`, {}, {
        headers: {
          'Authorization': `${jwt_token}`,
          'Username': `${username}`
        },
      }).then(response => {
        console.log(response.data)
        Notify.create({
          type: 'positive',
          timeout: 1000,
          message: 'Logged Out'
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
      sessionStorage.removeItem('username')
      sessionStorage.removeItem('jwt_token')
      this.isLoggedIn = false
    },
    toggleDarkMode (value) {
      if (value === null) {
        value = "auto"
      }
      this.$q.dark.set(value)
    },
  },
})
</script>
