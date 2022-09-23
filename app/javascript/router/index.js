import VueRouter from 'vue-router'
import MealIndex from 'components/meals/index'
import Stats from 'components/stats/index'

const routes = [
  { component: MealIndex, name: 'meals_index', path: '/' },
  { component: Stats, name: 'stats', path: '/stats' },
  // Admin Routes
]

const router = new VueRouter({
  routes
})

export default router
