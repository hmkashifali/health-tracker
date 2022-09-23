<template lang="pug">
  .admin-stats
    v-card
      v-card-title Stats
      v-card-text
        v-row
          .col-6
            v-row
              .col-3
                v-card(max-width="175")
                  v-card-title Meals Added
                  v-card-subtitle Last 7 Days
                  v-card-text
                    v-row(align="center")
                      v-col(cols="12" class="text-h3")
                        strong {{ firstCount }}
              .col-3
                v-card(max-width="175")
                  v-card-title Meals Added
                  v-card-subtitle Last 8-14 Days
                  v-card-text
                    v-row(align="center")
                      v-col(cols="12" class="text-h3")
                        strong {{ secondCount }}
      v-card-text
        v-data-table(:footer-props="footerProps" :headers="headers" :items="avePerDayStats" :loading="loading" :options.sync="options" :server-items-length="totalStats" class="elevation-1" loading-text="Loading... Please wait")
          template(v-slot:top)
            v-toolbar(flat)
              v-toolbar-title
                strong Average Calories per User
                br
                .subtitle-2.grey--text.text--darken-1 Last 7 Days
            v-row(class="mx-4 mt-3")
              v-text-field(v-model="search" label="Search")
          template(v-slot:no-data)
            | No Food Entries Yet



</template>

<script lang="coffee">
  export default
    data: ->
      avePerDayStats: []
      firstCount: 0
      headers: [
        { text: 'User', align: 'start', value: 'userName' },
        { text: 'Today', value: 'day0' },
        { text: 'Yesterday', value: 'day1' },
        { text: '2 Days Ago', value: 'day2' },
        { text: '3 Days Ago', value: 'day3' },
        { text: '4 Days Ago', value: 'day4' },
        { text: '5 Days Ago', value: 'day5' },
        { text: '6 Days Ago', value: 'day6' },
      ]
      loading: false
      options:
        page: 1,
        itemsPerPage: 10,
      search: ''
      secondCount: 0
      totalStats: -1
    computed:
      footerProps: ->
        props =
          showCurrentPage: true
    created: ->
      @.fetchStats()
    methods:
      fetchStats: ->
        @.loading = true
        @.$axios.get('meals/admin_stats', {params: { q: { 'name_cont': @.search }, per_page: @.options.itemsPerPage, page: @.options.page }})
          .then (response) =>
            @.firstCount = response.data.firstCount
            @.secondCount = response.data.secondCount
            @.totalStats = response.data.totalStats || -1
            @.avePerDayStats = response.data.stats
          .catch (error) -> console.log(error)
          .finally () => @.loading = false
    watch:
      options:
        deep: true
        handler: -> @.fetchStats()
      search: (val) -> @.fetchStats()
</script>

<style lang="sass" scoped>
</style>
