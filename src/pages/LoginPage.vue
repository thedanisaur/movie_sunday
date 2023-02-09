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
import cfg from '../../ms.config.json'

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
      const token = btoa(`${this.inputUsername.toLowerCase()}:${this.inputPassword}`)
      const host = cfg.service.user.host
      const port = cfg.service.user.port
      const login = cfg.service.user.login
      const response = await axios.post(`https://${host}:${port}${login}`, {}, {
        headers: {
          'Authorization': `Basic ${token}`
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
