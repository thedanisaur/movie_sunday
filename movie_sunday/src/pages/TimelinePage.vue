<template>
  <q-page class="flex flex-center">
    <div class="q-pa-md q-gutter-md" style="width: 95%; min-width: 600px;">
      <q-carousel
        v-model="slide"
        transition_prev="slide-right"
        transition_next="slide-left"
        transition_duration="100"
        animated
        infinite
        :autoplay="autoplay"
        arrows
        prev-icon="keyboard_double_arrow_left"
        next-icon="keyboard_double_arrow_right"
        control-type="regular"
        control-color="primary"
        padding
        swipeable
        thumbnails
        class="rounded-borders shadow-4"
        @mouseenter="autoplay = false"
        @mouseleave="autoplay = true"
      >
        <q-carousel-slide v-for="series in timeline" :key="series" :name="series.series_title" img-src="../assets/module-6.jpg">
          <q-item dense class="text-h2 text-white text-weight-bolder q-mt-xl" style="text-shadow: 2px 2px black;">
            <q-item-section>
              <q-item-label>
                {{ series.series_title }}
              </q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-avatar color="primary" size="128px" class="text-h2 text-white text-weight-bold">
                #{{ series.series_rank + 1 }}
              </q-avatar>
            </q-item-section>
          </q-item>
          <q-item class="text-h4 text-white text-weight-bolder" style="text-shadow: 2px 2px black;">
            <q-item-section>
              <q-item-label class="text-right">
                Rating: {{ parseFloat(series.series_rating).toFixed(1) }}%
              </q-item-label>
            </q-item-section>
          </q-item>
          <q-item class="q-mt-lg">
            <!-- <q-item-section>
            </q-item-section> -->
            <q-chip>Chosen By: {{ toTitleCase(series.series_chosen_by) }}</q-chip>
            <q-chip>Series: #{{ series.series_order }}</q-chip>
            <q-chip>Number of Movies:{{ series.series_movies ? series.series_movies.length : 0 }}</q-chip>
          </q-item>
        </q-carousel-slide>
      </q-carousel>
    </div>
  </q-page>
</template>

<script>
import { ref, defineComponent } from 'vue'
import axios from 'axios'

export default defineComponent({
  name: 'TimelinePage',
  data() {
    return {
      timeline: null,
      slide: null
    }
  },
  async created() {
    const response = await axios.get("http://localhost:1234/timeline")
    this.timeline = response.data
    this.slide = this.timeline[0].series_title
  },
  setup() {
    return {
      autoplay: ref(true)
    }
  },
  methods: {
    calcSmiley(dan_vote, nick_vote) {
      let d = 0.0
      let n = 0.0
      if (dan_vote == "GOOD") {
        d = 1.0
      }
      if (nick_vote == "GOOD") {
        n = 1.0
      }
      const value = (d + n) / 2
      if (value > .5) {
        return {smiley: "mood", color: "secondary"}
      } else if (value == .5) {
        return {smiley: "sentiment_neutral", color: "primary"}
      } else {
        return {smiley: "mood_bad", color: "red"}
      }
    },
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    }
  }
})
</script>
