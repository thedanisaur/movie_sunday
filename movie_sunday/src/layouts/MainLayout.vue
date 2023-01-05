<template>
  <q-layout view="lHh Lpr lFf">
    <q-drawer
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
    </q-drawer>
    
    <q-header elevated>
      <q-toolbar>
        <q-btn
          flat
          dense
          size="lg"
          icon="theaters"
          aria-label="Menu"
          @click="toggleLeftDrawer"
          title="Movie Sunday"
          label="Movie Sunday"
        />

        <q-toolbar-title>
          <q-btn
            flat
            dense
            size="lg"
            to="/series"
            title="Series"
            label="Series"
          />
          <q-btn
            flat
            dense
            size="lg"
            to="/ranking"
            title="Ranking"
            label="Ranking"
          />
          <q-btn
            flat
            dense
            size="lg"
            to="/trackers"
            title="Trackers"
            label="Trackers"
          />
        </q-toolbar-title>

        <div>Movie Sunday v{{ $q.version }}</div>

        <q-btn
          flat
          dense
          round
          icon="menu"
          aria-label="Menu"
          @click="toggleLeftDrawer"
        />
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
    EssentialLink
  },
  setup () {
    const leftDrawerOpen = ref(false)

    return {
      essentialLinks: linksList,
      leftDrawerOpen,
      toggleLeftDrawer () {
        leftDrawerOpen.value = !leftDrawerOpen.value
      }
    }
  }
})
</script>
