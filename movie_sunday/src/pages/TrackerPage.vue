<template>
  <q-page class="flex flex-center">
    <q-toolbar class="absolute-top bg-grey-2">
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
      <q-card v-for="tracker in trackers" :key="tracker" bordered style="min-width: 300px; max-width: 350px">
        <q-card-section>
          <!-- HEADER -->
          <q-parallax src="../assets/module-6.jpg" :height="150" style="opacity: 0.8;">
            <q-item class="q-pa-sm">
              <q-item-section class="side">
                <q-avatar color="grey-10" size="56px" class="text-h2 text-white text-weight-bold">
                  {{ tracker.tracker_count }}
                </q-avatar>
              </q-item-section>
              <q-item-section class="side">
                <q-item-label dense class="text-h5 text-white text-weight-bolder text-right" style="text-shadow: 2px 2px black;">
                  {{ tracker.tracker_text }}
                </q-item-label>
              </q-item-section>
            </q-item>
          </q-parallax>
          <!-- BODY -->
          <!-- FOOTER -->
          <q-chip icon="add_circle_outline">{{ toTitleCase(tracker.tracker_created_by) }}</q-chip>
          <q-chip icon="calendar_today">{{ tracker.tracker_created_on }}</q-chip>
          <q-separator />
        </q-card-section>
      </q-card>
    </div>
    <!-- DIALOGS -->
    <!-- TODO no-backdrop-dismiss fixes a bug on my dev machine -->
    <q-dialog no-backdrop-dismiss v-model="addTrackerDialog">
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
  </q-page>
</template>
<script>
import { ref, defineComponent } from 'vue'
import axios from 'axios'
import { Notify } from 'quasar'

export default defineComponent({
  name: 'TrackerPage',
  data () {
    return {
      trackers: null,
      isLoggedIn: sessionStorage.getItem('username') !== null
    }
  },
  setup () {
    return {
      addTrackerDialog: ref(false),
      inputTrackerText: ref(''),
      pua_toggle: ref('tracker_rank'),
      ad_toggle: ref('descending'),
    }
  },
  async created () {
    const response = await axios.get("http://localhost:1234/trackers")
    this.trackers = response.data
  },
  methods: {
    onReset () {
      this.inputTrackerText = ''
    },
    onSubmit () {
      Notify.create({
        type: 'positive',
        message: 'Submitted'
      })
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
    }
  },
})
</script>
