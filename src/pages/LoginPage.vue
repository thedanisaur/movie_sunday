<template>
  <q-page class="flex flex-center">
    <div class="q-pa-md">
      <q-form
          @submit="onSubmit"
          @reset="onReset"
          class="q-gutter-md"
        >
        <q-item-label class="text-h5 text-bold">Login:</q-item-label>
          <q-input
            v-model="inputUsername"
            filled
            hint="Username"
            required
          />
          <q-input
            v-model="inputPassword"
            filled
            hint="Password"
            :type="inputIsPwd ? 'password' : 'text'" 
            required
          >
          <template v-slot:append>
            <q-icon
                :name="inputIsPwd ? 'visibility_off' : 'visibility'"
                class="cursor-pointer"
                @click="inputIsPwd = !inputIsPwd"
            />
            </template>
          </q-input>
          
          <div class="row">
            <q-space />
            <q-btn dense flat color="primary" label="Clear" type="reset" class="q-mr-md" />
            <q-btn dense color="primary" label="Submit" type="submit" />
          </div>
        </q-form>
    </div>
  </q-page>
</template>

<script>
import { defineComponent, ref } from 'vue'
import axios from 'axios'
import { Notify } from 'quasar'
import cfg from '../../movie_sunday.config.json'

export default defineComponent({
  name: 'LoginPage',
  data () {
    return {
    }
  },
  setup () {
    return {
      inputUsername: ref(''),
      inputPassword: ref(''),
      inputIsPwd: ref(true),
    }
  },
  async created () {
  },
  methods: {
    onReset () {
      this.inputUsername = ''
      this.inputPassword = ''
      this.inputIsPwd = true
    },
    async onSubmit () {
      let token = `${this.inputUsername.toLowerCase()}:${this.inputPassword}`
      const host = cfg.service.user.host
      const port = cfg.service.user.port
      const login = cfg.service.user.login

      if (cfg.service.user.host.startsWith('http://')) {
        // Encrypt the user token. Yes this doesn't do much, but it should at least protect
        // the user's password and reduce the damage being done to the JWT window.
        const publicKeyEndpoint = cfg.service.user.public_key
        let response = await axios.get(`${host}:${port}${publicKeyEndpoint}`)
        const publicKey = response.data.public_key
        const tokenBuffer = (new TextEncoder).encode(token).buffer
        let publicKeyContents = publicKey.substring('-----BEGIN PUBLIC KEY-----\n'.length, publicKey.length - '\n-----END PUBLIC KEY-----'.length)
        const base64decoded = atob(publicKeyContents)
        const len = base64decoded.length
        const buffer = new ArrayBuffer(len)
        const uint8Array = new Uint8Array(buffer)
        for (let i = 0; i < len; i++) uint8Array[i] = base64decoded.charCodeAt(i)
        const cryptoKey = await crypto.subtle.importKey('spki', buffer, { name: 'RSA-OAEP', hash: 'SHA-512', }, true, ['encrypt'] )
        const encryptedTokenBuffer = await crypto.subtle.encrypt({ name: "RSA-OAEP" }, cryptoKey, tokenBuffer)
        token = String.fromCharCode(...new Uint8Array(encryptedTokenBuffer))
      }

      // Log in
      const response = await axios.post(`${host}:${port}${login}`, {}, {
        headers: {
          'Authorization': `Basic ${btoa(token)}`
        },
      }).then(response => {
        console.log(response.data)
        Notify.create({
          type: 'positive',
          timeout: 1000,
          message: 'Logged In'
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
      if (sessionStorage.getItem('username')) {
        this.$router.push('/')
      }
    },
  }
})
</script>
<style lang="scss" scoped>
</style>
