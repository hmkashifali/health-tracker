<template lang="pug">
  #app
    notifications
    v-dialog
    v-app
      v-navigation-drawer(v-model="drawer" :mini-variant.sync="mini" app class="lighten-1" :class="themeColor" dark permanent)
        v-list-item
          v-list-item-content
            v-list-item-title(class="text-h6") Health Tracker
            v-list-item-subtitle Track your routine
        v-divider
        v-list-item(class="px-2")
          v-list-item-avatar
            v-img(src="https://randomuser.me/api/portraits/lego/2.jpg")
          v-list-item-title {{ currentUser.name }}
          v-btn(icon @click.stop="mini = !mini")
            v-icon(mdi-chevron-left)
        v-divider

        v-list(dense)
          v-list-item(v-for="item in items" :class="activeLinkStyles(item)" :key="item.title" link @click="$router.push({ name: item.routeName })")
            v-list-item-icon
              v-icon {{ item.icon }}

            v-list-item-content
              v-list-item-title {{ item.title }}
        template(v-slot:append)
          .pa-2
            v-btn(v-if="isAdmin" block @click="switchToRegular") Switch to Regular User
            v-btn(v-else block @click="switchToAdmin") Switch to Admin User
      v-main
        v-container(fluid)
          template(v-if="!currentUser.isAdmin")
            v-alert(v-if="calorieLimitExceeded" border="left" colored-border elevation="2" type="error")
              | You have exceded your daily calorie limit
            v-alert(v-if="budgetLimitExceeded" border="left" colored-border elevation="2" type="error")
              | You have exceded your monthly budget limit
          router-view
</template>

<script lang="coffee">
  import { mapActions, mapState } from 'vuex'
  export default
    data: ->
      drawer: true,
      isAdmin: false
      items: [
        { title: 'Home', icon: 'mdi-home-city', routeName: 'meals_index' },
        { title: 'Stats', icon: 'mdi-chart-line', routeName: 'stats' },
        { title: 'My Account', icon: 'mdi-account', routeName: 'my_account' },
      ],
      mini: false,
    computed: Object.assign {}, mapState(['currentUser']),
      budgetLimitExceeded: ->
        @.currentUser.monthlyPriceLimitExceeded
      calorieLimitExceeded: ->
        @.currentUser.dailyCalorieLimitExceeded
      themeColor: ->
        if @.isAdmin then 'purple' else 'light-blue'

    created: ->
      @.fetchCurrentUser()
    methods: Object.assign {}, mapActions(['fetchCurrentUser']),
      activeLinkStyles: (item)->
        {'darken-3 rounded-r-xl': @.$route.name == item.routeName,
        "#{@.themeColor}":  @.$route.name == item.routeName}
      switchToAdmin: ->
        @.isAdmin = true
        console.log(@.$axios)
      switchToRegular: ->
        @.isAdmin = false
        console.log(@.$axios)

</script>

<style lang="sass" scoped>
</style>
