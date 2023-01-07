
const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/TimelinePage.vue') }
    ]
  },
  {
    path: '/series',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/TimelinePage.vue') }
    ]
  },
  {
    path: '/ratings',
    component: () => import('layouts/RatingsLayout.vue'),
    children: [
      { path: '', component: () => import('pages/RatingsPage.vue') }
    ]
  },
  {
    path: '/trackers',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/TrackerPage.vue') }
    ]
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue')
  }
]

export default routes
