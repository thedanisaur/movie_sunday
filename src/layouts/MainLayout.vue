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
          <!-- v{{ $q.version }} -->
          <!-- v0.1.0 -->
          <!-- <q-btn
            flat
            dense
            round
            icon="menu"
            aria-label="Menu"
            @click="toggleLeftDrawer"
            class="col-2"
          /> -->
          <q-btn v-if="isLoggedIn" flat icon-right="logout" label="Logout" @click="logout()" :to="'/'" />
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
          console.log(response.data)
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
        });
      }, 1_800_000), // 1_800_000 = Every 30 minutes
    }
  },
  setup () {
    return {
      
    }
  },
  methods: {
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
    }
  },
})
</script>
