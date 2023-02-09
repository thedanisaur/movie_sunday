<template>
  <q-page class="flex flex-center">
    <div class="q-pa-md q-gutter-md" style="width: 90%; min-width: 600px;">
      <q-item-label class="q-gutter-xl text-h3 text-bold">{{ week }}</q-item-label>
      <q-carousel
        v-model="slide"
        ref="slide"
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
        @transition="updateWeek()"
      >
        <q-carousel-slide v-for="series in timeline" :key="series" :name="series.series_title" :img-src="require('../assets/' + series.series_image)">
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
import cfg from '../../ms.config.json'

export default defineComponent({
  name: 'TimelinePage',
  data () {
    return {
      timeline: null,
      slide: null,
      week: ref('CURRENTLY VIEWING: ')
    }
  },
  async created () {
    const host = cfg.service.movie.host
    const port = cfg.service.movie.port
    const timeline = cfg.service.movie.timeline
    const response = await axios.get(`https://${host}:${port}${timeline}`)
    response.data.forEach((item, arr) => {
      item.series_image = this.randomImage()
    })
    this.timeline = response.data
    this.slide = this.timeline[0].series_title
  },
  setup () {
    return {
      autoplay: ref(true),
    }
  },
  methods: {
    toTitleCase (str) {
      return str.charAt(0).toUpperCase() + str.substr(1).toLowerCase()
    },
    updateWeek() {
      const title = this.$refs.slide.modelValue
      const series = this.timeline.find(s => s.series_title == title)
      if (series.series_title === this.timeline[0].series_title) {
        this.week = 'CURRENTLY VIEWING: '
      } else {
        this.week = series.series_created_on + ":"
      }
    },
    randomImage() {
      const images = [
          'module-6.jpg',
        ]
      const image = images[Math.floor(Math.random() * images.length)]
      return image
    }
  }
})
</script>
