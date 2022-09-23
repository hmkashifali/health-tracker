<template lang="pug">
  .meals-index
    v-data-table(:headers="caloriesHeader" :items="calories" :loading="loadingCalories" class="elevation-1" loading-text="Loading... Please wait" sort-by="foodName")
      template(v-slot:top)
        v-toolbar(flat)
          v-toolbar-title Per Day Calories
          v-spacer
          v-switch(v-model='loadExceedingCaloriesOnly' color="error" label="Limit Exceeding Only" :value="true")
        v-row(class="mx-2")
          .col-4
            v-menu(v-model="caloriesTookAtFromMenu" :close-on-content-click="false" :nudge-right="40" transition="scale-transition" offset-y min-width="auto")
              template(v-slot:activator="{ on, attrs }")
                v-text-field(label="From" v-bind="attrs" v-model="caloriesTookAtFrom" v-on="on" append-icon="mdi-calendar" clearable readonly)
              v-date-picker(v-model="caloriesTookAtFrom" @input="caloriesTookAtFromMenu = false")
          .col-4
            v-menu(v-model="caloriesTookAtToMenu" :close-on-content-click="false" :nudge-right="40" transition="scale-transition" offset-y min-width="auto")
              template(v-slot:activator="{ on, attrs }")
                v-text-field(label="To" v-bind="attrs" v-model="caloriesTookAtTo" v-on="on" append-icon="mdi-calendar" clearable readonly)
              v-date-picker(v-model="caloriesTookAtTo" @input="caloriesTookAtToMenu = false")
      template(v-slot:item.calories="{ item }")
        .calories-under-limit(v-if="item.calories < currentUser.perDayCalorieLimit") {{ item.calories }}
        v-chip(v-else color="red" dark) {{ item.calories }}
      template(v-slot:item.actions="{ item }")
        v-icon(class="mr-2" small title="See Food Entries" @click="goToDetails(item)") mdi-eye
      template(v-slot:no-data)
        | No Stats Yet

    .divider.my-5

    v-data-table(:headers="expenseHeader" :items="expenses" :loading="loadingExpenses" class="elevation-1" loading-text="Loading... Please wait" sort-by="foodName")
      template(v-slot:top)
        v-toolbar(flat)
          v-toolbar-title Per Month Expenses
          v-spacer
          v-switch(v-model='loadExceedingExpensesOnly' color="error" label="Limit Exceeding Only" :value="true")
        v-row(class="mx-2")
          .col-4
            v-menu(v-model="expensesTookAtFromMenu" :close-on-content-click="false" :nudge-right="40" transition="scale-transition" offset-y min-width="auto")
              template(v-slot:activator="{ on, attrs }")
                v-text-field(label="From" v-bind="attrs" v-model="expensesTookAtFrom" v-on="on" append-icon="mdi-calendar" clearable readonly)
              v-date-picker(v-model="expensesTookAtFrom" @input="expensesTookAtFromMenu = false")
          .col-4
            v-menu(v-model="expensesTookAtToMenu" :close-on-content-click="false" :nudge-right="40" transition="scale-transition" offset-y min-width="auto")
              template(v-slot:activator="{ on, attrs }")
                v-text-field(label="To" v-bind="attrs" v-model="expensesTookAtTo" v-on="on" append-icon="mdi-calendar" clearable readonly)
              v-date-picker(v-model="expensesTookAtTo" @input="expensesTookAtToMenu = false")
      template(v-slot:item.totalPrice="{ item }")
        .price-under-limit(v-if="item.totalPrice < currentUser.perMonthPriceLimit") {{ item.totalPrice }}
        v-chip(v-else color="red" dark) {{ item.totalPrice }}
      template(v-slot:item.actions="{ item }")
        v-icon(class="mr-2" small title="See Food Entries" @click="goToExpenseDetails(item)") mdi-eye
      template(v-slot:no-data)
        | No Stats Yet

</template>

<script lang="coffee">
  import { mapState } from 'vuex'

  export default
    data: ->
      caloriesHeader: [
        {
          text: 'Date',
          align: 'start',
          value: 'tookAt',
        },
        { text: 'Calories', value: 'calories' },
        { text: 'Actions', align: 'center', value: 'actions', sortable: false }
      ],
      calories: []
      expenses: []
      expenseHeader: [
        {
          text: 'Month',
          align: 'start',
          value: 'month',
        },
        { text: 'Total Price($)', value: 'totalPrice' },
        { text: 'Actions', align: 'center', value: 'actions', sortable: false }
      ],
      loadingCalories: false
      loadingExpenses: false
      loadExceedingCaloriesOnly: false
      loadExceedingExpensesOnly: false
      caloriesTookAtFrom: ''
      caloriesTookAtFromMenu: false
      caloriesTookAtTo: ''
      caloriesTookAtToMenu: false
      expensesTookAtFrom: ''
      expensesTookAtFromMenu: false
      expensesTookAtTo: ''
      expensesTookAtToMenu: false
    computed: Object.assign {}, mapState({ 'currentUser' })
    created: ->
      @.fetchCalories()
      @.fetchExpenses()
    methods:
      fetchCalories: ->
        @.loadingCalories = true
        params = {}
        params['took_at_gteq'] = new Date(@.caloriesTookAtFrom).toISOString() if @.caloriesTookAtFrom
        if @.caloriesTookAtTo
          toDate = new Date(@.caloriesTookAtTo)
          toDateStr = toDate.setDate(toDate.getDate() + 1)
          params['took_at_lt'] = toDate.toISOString()
        @.$axios.get('meals/calories_per_day', params: { q: params, load_exceeding_only: @.loadExceedingCaloriesOnly })
          .then (response) =>
            @.calories = response.data
          .finally () =>
            @.loadingCalories = false

      fetchExpenses: ->
        @.loadingExpenses = true
        params = {}
        params['took_at_gteq'] = new Date(@.expensesTookAtFrom).toISOString() if @.expensesTookAtFrom
        if @.expensesTookAtTo
          toDate = new Date(@.expensesTookAtTo)
          toDateStr = toDate.setDate(toDate.getDate() + 1)
          params['took_at_lt'] = toDate.toISOString()
        @.$axios.get('meals/expenses_per_month', params: { q: params, load_exceeding_only: @.loadExceedingExpensesOnly })
          .then (response) =>
            @.expenses = response.data
          .finally () =>
            @.loadingExpenses = false
      goToCalorieDetails: (item) ->
        @.$router.push { name: 'meals_index', query: { from: item.tookAt, to: item.tookAt } }
      goToExpenseDetails: (item) ->
        @.$router.push { name: 'meals_index', query: { from: item.beginningOfMonth, to: item.currentDate } }

    watch:
      dialogDelete: (val) -> val || @.closeDelete()
      loadExceedingCaloriesOnly: -> @.fetchCalories()
      caloriesTookAtFrom: (val) -> @.fetchCalories()
      caloriesTookAtTo: (val) -> @.fetchCalories()
      loadExceedingExpensesOnly: -> @.fetchExpenses()
      expensesTookAtFrom: (val) -> @.fetchExpenses()
      expensesTookAtTo: (val) -> @.fetchExpenses()
</script>

<style lang="sass" scoped>
</style>
