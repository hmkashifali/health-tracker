<template lang="pug">
  .meals-index
    meal-maint-modal(@add="updateData" @update="updateData")
    v-data-table(:headers="headers" :items="meals" :loading="loading" :options.sync="options" :server-items-length="totalItems" class="elevation-1" loading-text="Loading... Please wait")
      template(v-slot:top)
        v-toolbar(flat)
          v-toolbar-title Meals
          v-spacer
          v-btn(class="mb-2" color='primary' dark @click="addMeal") Add New Meal
        v-row(class="mx-2")
          .col-4
            v-text-field(v-model="search" label="Search")
          .col-4
            v-menu(v-model="tookAtFromMenu" :close-on-content-click="false" :nudge-right="40" transition="scale-transition" offset-y min-width="auto")
              template(v-slot:activator="{ on, attrs }")
                v-text-field(label="From" v-bind="attrs" v-model="tookAtFrom" v-on="on" append-icon="mdi-calendar" clearable readonly)
              v-date-picker(v-model="tookAtFrom" @input="tookAtFromMenu = false")
          .col-4
            v-menu(v-model="tookAtToMenu" :close-on-content-click="false" :nudge-right="40" transition="scale-transition" offset-y min-width="auto")
              template(v-slot:activator="{ on, attrs }")
                v-text-field(label="To" v-bind="attrs" v-model="tookAtTo" v-on="on" append-icon="mdi-calendar" clearable readonly)
              v-date-picker(v-model="tookAtTo" @input="tookAtToMenu = false")
      template(v-slot:item.calories="{ item }")
        v-chip(:color="getColor(item.calories)" dark) {{ item.calories }}
      template(v-slot:item.actions="{ item }")
        v-icon(class="mr-2" small @click="editItem(item)") mdi-pencil
        v-icon(small @click="confirmDeletion(item)") mdi-delete
      template(v-slot:no-data)
        | No Meal Added Yet

</template>

<script lang="coffee">
  import { Mixin as MealMaintMixin } from './maint-modal'
  import { mapActions, mapState } from 'vuex'
  export default
    data: ->
      dialogDelete: false
      editedIndex: -1,
      editedItem: {
        name: '',
        calories: 0,
        fat: 0,
        carbs: 0,
        protein: 0,
      },
      meals: []
      loading: false
      options:
        page: 1,
        itemsPerPage: 10,
      paginationOptions:
        page: 1
        itemsPerPage: 100
      pagination: {}
      search: ''
      tookAtFrom: ''
      tookAtFromMenu: false
      tookAtTo: ''
      tookAtToMenu: false
      totalItems: -1
    computed: Object.assign {}, mapState({ 'currentUser' }),
      headers: ->
        header = [
          {
            text: 'Food',
            align: 'start',
            value: 'foodName',
          },
          { text: 'Calories', value: 'calorieCount' },
          { text: 'Took On', value: 'tookAt' },
          { text: 'Price($)', value: 'price' },
        ]
        header.push { text: 'Added by', value: 'user.name' } if @.currentUser.isAdmin
        header.push { text: 'Actions', align: 'center', value: 'actions', sortable: false }
        header

    created: ->
      @.tookAtFrom = @.$route.query.from || ''
      @.tookAtTo = @.$route.query.to || ''
      @.fetchData()
    methods: Object.assign {}, mapActions(['fetchCurrentUser']),
      closeDelete: ->
        @.dialogDelete = false
      confirmDeletion: (item) ->
        @.$modal.show('dialog', {
          title: 'Delete Meal',
          text: "Are you sure, you want to delete \"#{item.foodName}\""
          buttons: [ {
              title: 'Cancel',
              handler: =>
                @.$modal.hide('dialog')
            },
            {
              title: 'Yes, Delete',
              handler: =>
                @.deleteMeal(item).then (response) =>
                  @.$modal.hide('dialog')
                  @.$notify({ title: 'Horray!', text: 'Meal Successfully Deleted', type: 'success'})
                  @.fetchData()
                .catch (error) =>
                  @.$notify({ title: 'Ooops!', text: 'Meal Could not be Deleted', type: 'error'})
            }
          ]
        })
      deleteMeal: (meal)->
        new Promise (resolve, reject) =>
          @.$axios.delete("meals/#{meal.id}")
            .then (response) =>
              resolve true
            .catch (error) =>
              reject(error)
      editItem: (item) ->
        @.editMeal(item, @.meals.indexOf(item))
      fetchData: ->
        @.loading = true
        params = {}
        params['food_name_cont'] = @.search if @.search.length
        params['took_at_gteq'] = new Date(@.tookAtFrom).toISOString() if @.tookAtFrom
        if @.tookAtTo
          toDate = new Date(@.tookAtTo)
          toDateStr = toDate.setDate(toDate.getDate() + 1)
          params['took_at_lt'] = toDate.toISOString()
        @.$axios.get('meals', { params: {q: params, per_page: @.options.itemsPerPage, page: @.options.page}})
          .then (response) =>
            @.totalItems = response.data.totalItems || -1
            @.meals = response.data.items
          .finally () =>
            @.loading = false
      updateData: ->
        @.fetchData()
        @.fetchCurrentUser()

    mixins: [MealMaintMixin]
    watch:
      dialogDelete: (val) -> val || @.closeDelete()
      options:
        deep: true
        handler: -> @.fetchData()
      search: (val) -> @.fetchData()
      tookAtFrom: (val) -> @.fetchData()
      tookAtTo: (val) -> @.fetchData()
</script>

<style lang="sass" scoped>
</style>
