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

export default defineComponent({
  name: 'RatingsPage',
  data () {
    return {
      ratings: null
    }
  },
  setup () {
    return {
      inputUsername: ref(''),
      inputPassword: ref(''),
      inputIsPwd: ref(true)
    }
  },
  async created () {
  },
  methods: {
    onReset () {
      this.inputUsername = ''
      this.inputPassword = ''
      inputIsPwd = true
    },
    onSubmit () {
      this.useQuasar().notify({
        color: 'green-4',
        textColor: 'white',
        icon: 'cloud_done',
        message: 'Submitted'
      })
    },
  }
})
</script>
<style lang="scss" scoped>
</style>
