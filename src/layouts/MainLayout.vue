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
      }, 100000) // 100000 is just under 2 min
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
