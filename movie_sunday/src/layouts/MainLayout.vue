<template>
  <q-layout view="lHh Lpr lFf">
    <!-- <q-drawer
      v-model="leftDrawerOpen"
      overlay=true
      show-if-above
      bordered
    >
      <q-list>
        <q-item-label header>
          Essential Links
        </q-item-label>

        <EssentialLink
          v-for="link in essentialLinks"
          :key="link.title"
          v-bind="link"
        />
      </q-list>
    </q-drawer> -->
    
    <q-header elevated>
      <q-toolbar>
        <q-btn
          flat
          dense
          size="lg"
          to="/"
          icon="theaters"
          aria-label="Menu"
          @click="toggleLeftDrawer"
          title="Movie Sunday"
          label="Movie Sunday"
          class="q-mr-md col-2"
        />

        <q-tabs no-caps align="justify" class="col-9">
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
            to="/ratings"
            title="Ratings"
            label="Ratings"
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
          v0.1.0
          <q-btn
            flat
            dense
            round
            icon="menu"
            aria-label="Menu"
            @click="toggleLeftDrawer"
            class="col-2"
          />
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
import EssentialLink from 'components/EssentialLink.vue'
import { fasFontAwesome } from '@quasar/extras/fontawesome-v6'

const linksList = [
  {
    title: 'Docs',
    caption: 'quasar.dev',
    icon: 'school',
    link: 'https://quasar.dev'
  },
  {
    title: 'Github',
    caption: 'github.com/quasarframework',
    icon: 'code',
    link: 'https://github.com/quasarframework'
  },
]

export default defineComponent({
  name: 'MainLayout',

  components: {
    // EssentialLink
  },
  setup () {
    const leftDrawerOpen = ref(false)

    return {
      // essentialLinks: linksList,
      leftDrawerOpen,
      toggleLeftDrawer () {
        leftDrawerOpen.value = !leftDrawerOpen.value
      }
    }
  }
})
</script>
