/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'app' %> (and
// <%= stylesheet_pack_tag 'app' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

// import Vue from 'vue'
// import App from '../app.vue'

// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     render: h => h(App)
//   }).$mount()
//   document.body.appendChild(app.$el)
// })


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'app' %> to your layout
// Then add this markup to your html template:
//


import Vue from 'vue'
import vuetify from 'plugins/vuetify'
import VueTrancate from 'vue-truncate'
import VueLodash from 'vue-lodash'


// Components
import App from 'components/app.vue'
import BaseModal from 'components/shared/base-modal'
import VModal from 'vue-js-modal'
Vue.use(VModal, { dialog: true })
import Notifications from 'vue-notification'
Vue.use(Notifications)

// router
import VueRouter from 'vue-router'
import router from 'router'
Vue.use(VueRouter)

// Store
import store from 'store/index'

// Plugins
import Axios from 'plugins/axios'
// Vue.use(Axios)

Vue.prototype.$axios = Axios

import _ from 'lodash'
Vue.use(VueLodash, { lodash: _ })


Vue.use(VueTrancate)
Vue.component('base-modal', BaseModal)
document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#vue-app',
    store,
    router,
    vuetify,
    data: () => {
      return {
        _
      }
    },
    components: { App, BaseModal }
  })
})
//
//
//
// If the project is using turbolinks, install 'vue-turbolinks':
//
// yarn add vue-turbolinks
//
// Then uncomment the code block below:
//
// import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// Vue.use(TurbolinksAdapter)
//
// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: () => {
//       return {
//         message: "Can you say hello?"
//       }
//     },
//     components: { App }
//   })
// })
