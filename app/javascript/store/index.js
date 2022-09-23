import _ from 'lodash'
import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'plugins/axios'
Vue.use(Vuex)

const store = new Vuex.Store({
  actions: {
    fetchCurrentUser(context) {
      axios.get('users/me').then(response => {
        context.commit('setCurrentUser', response.data)
      }).catch(error => {console.log('Could not fetch user info')})
    }
  },
  mutations: {
    setCurrentUser(state, user) {
      state.currentUser = user
    }
  },
  state: {
    currentUser: {}
  },
})
export default store
