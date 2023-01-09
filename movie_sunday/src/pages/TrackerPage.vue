<template>
  <q-page class="flex flex-center">
    <div class="q-pa-md q-gutter-md row flex-center">
      <q-card v-for="tracker in trackers" :key="tracker" bordered style="min-width: 250px; max-width: 350px">
        <q-card-section>
          <!-- HEADER -->
          <q-parallax src="../assets/module-6.jpg" :height="150" style="opacity: 0.8;">
            <q-item class="q-pa-sm">
              <q-item-section>
                <q-avatar color="grey-10" size="56px" class="text-h2 text-white text-weight-bold">
                  {{ tracker.tracker_count }}
                </q-avatar>
              </q-item-section>
              <q-item-section>
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
  </q-page>
</template>

<script>
import { defineComponent } from 'vue'
import axios from 'axios'

export default defineComponent({
  name: 'TrackerPage',
  data() {
    return {
      trackers: null
    }
  },
  async created() {
    const response = await axios.get("http://localhost:1234/trackers")
    console.log(response.data)
    this.trackers = response.data
  },
  methods: {
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    }
  },
})
</script>
