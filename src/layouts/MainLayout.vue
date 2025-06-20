<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated>
      <q-toolbar>
        <q-btn
          flat
          dense
          ref="logoRef"
          size="lg"
          to="/"
          icon="theaters"
          aria-label="Timeline"
          title="Movie Sunday"
          :label="showLabel ? 'Movie Sunday' : ''"
          class="q-mr-md col-2"
          :class="{
            'active-tab': $route.path === '/'
          }"
        />
        <q-tabs no-caps inline-label align="justify" class="col-8">
          <q-route-tab
            flat
            dense
            size="lg"
            to="/series"
            title="Series"
            label="Series"
            icon="photo_library"
          />
          <q-route-tab
            flat
            dense
            size="lg"
            to="/movies"
            title="Movies"
            label="Movies"
            icon="camera"
          />
          <q-route-tab
            flat
            dense
            size="lg"
            to="/trackers"
            title="Trackers"
            label="Trackers"
            icon="satellite_alt"
          />
          <q-route-tab
            v-if="isLoggedIn"
            flat
            dense
            size="lg"
            to="/analytics"
            title="Analytics"
            label="Analytics"
            icon="equalizer"
          />
        </q-tabs>
        <q-space></q-space>
        <q-btn v-if="isLoggedIn" flat icon="account_circle" size="lg" class="q-mr-sm">
          <q-menu>
            <div class="row no-wrap q-pa-md">
              <div class="column" style="min-width: 220px;">
                <div class="text-h6 q-mb-none">Settings</div>
                <q-item-label caption class="q-mb-md">v{{ $q.version }}&nbsp;-&nbsp;v0.1.0</q-item-label>
                <div class="q-mb-none">UI Mode: </div>
                <q-toggle v-model="darkMode" toggle-indeterminate @click="darkModeToggle(darkMode)" :label="darkModeToggleLabel()" />
                <q-btn color="primary" flat label="Change&nbsp;Password" icon-right="replay" @click="passwordDialogOnToggle()" v-close-popup />
              </div>
              <q-separator vertical inset class="q-mx-lg" />
              <div class="column items-center" style="min-width: 130px;">
                <q-avatar size="72px"><img :src=defaultImage></q-avatar>
                <div class="text-bold text-h6 q-mt-xs q-mb-md">{{username}}</div>
                <q-btn color="primary" flat label="Logout&nbsp;" icon-right="logout" @click="logout()" :to="'/'" v-close-popup />
              </div>
            </div>
          </q-menu>
        </q-btn>
        <q-btn v-else flat icon-right="login" label="Login" :to="'/login'" class="q-mr-sm" />
      </q-toolbar>
    </q-header>
    <q-page-container>
      <router-view />
    </q-page-container>
    <!-- Dialogs -->
    <q-dialog v-model="passwordDialog">
      <q-card class="q-pa-md" style="min-width: 500px;">
        <q-form
          @submit="passwordDialogOnSubmit"
          @reset="passwordDialogOnReset"
          class="q-gutter-md"
          style="min-width: 500px"
        >
          <q-input v-model="currentPassword" filled :type="isPwd ? 'password' : 'text'" :rules="[val => !!val || 'Password is required']" hint="Current Password" class="q-mb-lg">
            <template v-slot:append>
              <q-icon :name="isPwd ? 'visibility_off' : 'visibility'" class="cursor-pointer" @click="isPwd = !isPwd"/>
            </template>
          </q-input>
          <q-input v-model="newPassword" filled :type="isPwd ? 'password' : 'text'" :rules="[val => !!val || 'New Password is required']" hint="New Password" class="q-mb-lg">
            <template v-slot:append>
              <q-icon :name="isPwd ? 'visibility_off' : 'visibility'" class="cursor-pointer" @click="isPwd = !isPwd"/>
            </template>
          </q-input>
          <q-input v-model="retypePassword" filled :disable="this.newPassword.length === 0" :type="isPwd ? 'password' : 'text'" :rules="[passwordConfirm]" hint="Retype New Password" class="q-mb-md">
            <template v-slot:append>
              <q-icon :name="isPwd ? 'visibility_off' : 'visibility'" class="cursor-pointer" @click="isPwd = !isPwd"/>
            </template>
          </q-input>
          <q-separator />
          <q-card-actions>
            <q-btn dense flat color="primary" label="Cancel" @click="passwordDialogOnToggle()" v-close-popup />
            <q-space />
            <q-btn dense flat color="primary" label="Clear" type="reset" :disable="passwordDialogButtonDisabledReset()" class="q-mr-md" />
            <q-btn dense color="primary" label="Submit" type="submit" :disable="passwordDialogButtonDisabledSubmit()" />
          </q-card-actions>
        </q-form>
      </q-card>
    </q-dialog>
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
  created () {
    if (this.isLoggedIn) {
      this.scheduleRefreshToken()
    }
  },
  data () {
    return {
      darkMode: ref(this.$q.dark.mode),
      defaultImage: `img/missing.jpg`,
      isLoggedIn: sessionStorage.getItem('username') !== null,
      loginVerificationInterval: setInterval(() => {
        this.isLoggedIn = sessionStorage.getItem('username') !== null
      }, 1000),
      // fetchImageInterval: setInterval(async () => {
      //   const username = sessionStorage.getItem('username')
      //   const jwt_token = sessionStorage.getItem('jwt_token')
      //   const host = cfg.service.movie.host
      //   const port = cfg.service.movie.port
      //   const movies = cfg.service.movie.movies
      //   const movie_response = await axios.get(`${host}:${port}${movies}`)
      //   movie_response.data.slice().reduce(async (a, movie) => {
      //     // All this does is wait for the previous movie to finish
      //     await a;
      //     // If the previous movie was found try looking for this image
      //     const img_host = cfg.service.image.host
      //     const img_port = cfg.service.image.port
      //     const images = cfg.service.image.images
      //     const image_response = await axios.get(`${img_host}:${img_port}${images}/${movie.movie_name}`).catch( error => {
      //       const image_json = JSON.stringify({
      //         "movie_title": movie.movie_title,
      //         "movie_name": movie.movie_name,
      //         "series_name": movie.series_name
      //       })
      //       console.log(`fetching: ${movie.movie_name}`)
      //       axios.post(`${img_host}:${img_port}${images}`, image_json, {
      //         headers: {
      //           'Authorization': `${jwt_token}`,
      //           'Content-Type': 'application/json',
      //           'Username': `${username}`,
      //         },
      //       }).then(response => {
      //         console.log(response.data)
      //         Notify.create({
      //           type: 'positive',
      //           timeout: 1000,
      //           message: 'Image Fetched!'
      //         })
      //       }).catch(error => {
      //         if (error.response) {
      //           Notify.create({
      //             type: 'negative',
      //             message: 'Failed to fetch image'
      //           })
      //           console.log(error.response.data)
      //         } else {
      //           console.log(error)
      //         }
      //       })
      //       return Promise.reject(new Error('fetched'))
      //     })
      //   }, Promise.resolve()).catch(error => {
      //     if (error !== 'fetched') {
      //       return
      //     } else {
      //       console.log(error)
      //     }
      //   })
      // }, cfg.service.image.fetch_milliseconds),
      logoWidth: ref(0),
      logoObserver: null,
    }
  },
  computed: {
    username () {
      return sessionStorage.getItem('username')
    },
    showLabel () {
      return this.logoWidth >= 200
    }
  },
  watch: {
    isLoggedIn (newVal) {
      if (newVal) {
        this.scheduleRefreshToken()
      } else if (this.refreshTimeout) {
        clearTimeout(this.refreshTimeout)
      }
    }
  },
  beforeUnmount () {
    const element = this.$refs.logoRef?.$el
    if (this.logoObserver && element) {
      this.logoObserver.unobserve(element)
    }
    if (this.refreshTimeout) {
      clearTimeout(this.refreshTimeout)
    }
  },
  mounted () {
    const element = this.$refs.logoRef?.$el
    if (!element) return

    this.logoObserver = new ResizeObserver(entries => {
      const entry = entries[0]
      this.logoWidth = entry.contentRect.width
    })

    this.logoObserver.observe(element)
  },
  setup () {
    return {
      passwordDialog: ref(false),
      currentPassword: ref(''),
      newPassword: ref(''),
      retypePassword: ref(''),
      isPwd: ref(true),
    }
  },
  methods: {
    darkModeToggle (value) {
      if (value === null) {
        value = "auto"
      }
      this.$q.dark.set(value)
    },
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
    parseJwt (token) {
      const base64Url = token.split('.')[1]
      const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/')
      const jsonPayload = decodeURIComponent(atob(base64).split('').map(c => {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2)
      }).join(''))
      return JSON.parse(jsonPayload)
    },
    passwordConfirm (val) {
      if (!val) return 'Please confirm your password';
      if (val !== this.newPassword) return 'Passwords do not match';
      return true;
    },
    passwordDialogButtonDisabledReset () {
      return this.currentPassword.length === 0 && this.newPassword.length === 0 && this.retypePassword.length === 0
    },
    passwordDialogButtonDisabledSubmit () {
      return this.currentPassword.length === 0 ||
        this.newPassword.length === 0 ||
        this.retypePassword.length === 0 ||
        this.newPassword !== this.retypePassword
    },
    async passwordDialogOnReset () {
      this.currentPassword = ''
      this.newPassword = ''
      this.retypePassword = ''
    },
    async passwordDialogOnSubmit () {
      console.log("submitted")
      const jwt_token = sessionStorage.getItem('jwt_token')
      const host = cfg.service.user.host
      const port = cfg.service.user.port
      const user = cfg.service.user.user
      const payload = {
        "current": this.currentPassword,
        "updated": this.newPassword,
      }
      const response = await axios.put(`${host}:${port}${user}`, payload, {
        headers: {
          'Authorization': `${jwt_token}`,
          'Content-Type': 'application/json',
        },
      }).then(response => {
        console.log(response.data)
        Notify.create({
          type: 'positive',
          timeout: 1000,
          message: 'Password Updated'
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
    async passwordDialogOnToggle () {
      this.passwordDialogOnReset()
      this.passwordDialog = !this.passwordDialog
    },
    async refreshToken () {
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
        sessionStorage.setItem('username', response.data.username)
        sessionStorage.setItem('jwt_token', response.data.token)
        Notify.create({
          type: 'positive',
          timeout: 1000,
          message: 'Refreshed Token'
        })
        this.scheduleRefreshToken()
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
    },
    scheduleRefreshToken () {
      const payload = this.parseJwt(sessionStorage.getItem('jwt_token'))
      if (!payload || !payload.exp) {
        console.error('Invalid token — cannot schedule refresh')
        return
      }

      const expirationMs = payload.exp * 1000
      // Refresh at the half way mark of the token expiring
      const refreshIntervalMs = (payload.exp - payload.iat) * 1000 / 2
      const now = Date.now()
      const refreshTimeMs = expirationMs - refreshIntervalMs
      const delayMs = Math.max(refreshTimeMs - now, 0)

      if (this.refreshTimeout) {
        clearTimeout(this.refreshTimeout)
      }

      this.refreshTimeout = setTimeout(this.refreshToken, delayMs)
    },
  },
})
</script>
<style lang="scss" scoped>
.active-tab {
  border-bottom: 2px solid white;
}
</style>