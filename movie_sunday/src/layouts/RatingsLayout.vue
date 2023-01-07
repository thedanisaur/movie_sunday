<template>
  <q-layout view="lHh Lpr lFf">
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
          class="col-2"
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
      <q-toolbar class="bg-white">
        <q-icon name="movie" class="col-1" size="xl" color=primary />
        <q-item v-for="item in headerItems" :key="item" class="col-2">
          <q-icon :name="item.icon_name" size="md" color=primary class="q-gutter-sm q-mt-md" />
          <q-item class="text-black q-pl-sm q-mt-md">{{ item.text }}</q-item>
          <q-separator />
        </q-item>
      </q-toolbar>
    </q-header>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent, ref } from 'vue'

export default defineComponent({
  name: 'MainLayout',

  components: {
    // EssentialLink
  },
  data () {
    return {
      headerItems: [
        { 
          icon_name: "camera_roll",
          text: "Series"
        },
        { 
          icon_name: "accessible",
          text: "Chosen By"
        },
        { 
          icon_name: "tag",
          text: "Movies"
        },
        { 
          icon_name: "thumb_up",
          text: "Good Votes"
        },
        { 
          icon_name: "thumb_down",
          text: "Bad Votes"
        },
        { 
          icon_name: "star",
          text: "Rating"
        },

      ]
    }
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
