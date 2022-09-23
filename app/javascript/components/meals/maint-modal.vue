<template lang="pug">
  .line-item-form
    base-modal(name="meal-maint-modal" :title="header" :loading="loading" @before-open="beforeOpen" @before-close="beforeClose")
      template(#body)
        v-card-text
          v-form(v-model="formValid" lazy-validation ref="form")
            v-row
              v-text-field.col-6(v-model="mealLocal.foodName" label="Meal" required :disabled="loading" :loading="loading" :rules="validationRules.foodName")
              v-text-field.col-6(v-model="mealLocal.calorieCount" label="Calories" required type="number" :loading="loading" :disabled="loading" :rules="validationRules.calorieCount")
              v-menu(v-model="tookAtMenu" :close-on-content-click="false" :nudge-right="40" transition="scale-transition" offset-y min-width="auto")
                template(v-slot:activator="{ on, attrs }")
                  v-text-field.col-6(v-bind="attrs" v-model="mealLocal.tookAt" v-on="on" append-icon="mdi-calendar" label="Took At" readonly required)
                v-date-picker(v-model="mealLocal.tookAt" @input="tookAtMenu = false")
              v-text-field.col-6(v-model="mealLocal.price" label="Price" required type="number" :loading="loading" :disabled="loading" :rules="validationRules.price")
              v-autocomplete.col-12(v-if="currentUser.isAdmin" v-model="mealLocal.userId" item-text="name" item-value="id" label="User" :loading="loadingUsers" :items="users" :required="currentUser.isAdmin")

      template(#footer)
        v-card-actions
          v-spacer
          v-btn(@click="closeModal" text) Cancel
          v-btn.white--text(@click="submit" color="green" :disabled="!submitBtnEnabled") {{ submitBtnText }}

</template>

<script lang="coffee">
  import { mapState } from 'vuex'
  import { mapKeys } from 'utils/helper_methods.coffee'

  export Mixin =
    methods:
      addMeal: ->
        @.$modal.show 'meal-maint-modal'
      editMeal: (meal, index) ->
        @.$modal.show 'meal-maint-modal', { meal, index }

  MealMaintModal =
    props:
      meal:
        type: Object
        default: -> {}

    data: -> {
      mealDefault: {
        calorieCount: 0,
        foodName: '',
        price: 0,
        tookAt: (new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10)
      },
      formValid: false
      mealLocal: {}
      index: null
      isEdit: false
      loading: false
      loadingUsers: false
      tookAtMenu: false
      users: []
      validationRules:
        calorieCount: [
          (v) -> ("#{v}".length? || 'Calries are required'),
          (v) -> v > -1 || 'Calores cannot be negative'
        ]
        foodName: [(v) -> !!v || 'Meal is required']
        price: [
          (v) -> ("#{v}".length? || 'Price required')
          (v) -> v > -1 || 'Price cannot be negative'
        ]
        tookAt: [(v) -> (!!v || 'Took at is required')]
    }

    computed: Object.assign {}, mapState({ 'currentUser' }),
      header: ->
        if @.isEdit then 'Update Meal' else 'Add Meal'

      submitBtnEnabled: ->
        flag = !@.loading && @.mealLocal.foodName?.length && @.mealLocal.calorieCount? && @.mealLocal.price? && @.mealLocal.tookAt?
        flag = if @.currentUser.isAdmin then flag && @.mealLocal.userId? else flag
        flag && @.formValid

      submitBtnText: ->
        if @.isEdit then 'Update' else 'Add'

    methods:
      beforeClose: (event)->
        # console.log(event)

      beforeOpen: (event) ->
        @.loadUsers()
        @.isEdit = false
        @.mealLocal = Object.assign {}, @.mealDefault
        @.mealLocal.userId = @.currentUser.id if @.currentUser.isAdmin
        if event.params?.meal?
          @.mealLocal = Object.assign {}, event.params?.meal
          @.isEdit = true
        @.index = event.params?.index

      closeModal: ->
        @.$modal.hide 'meal-maint-modal'

      loadUsers: ->
        return [@.currentUser] unless @.currentUser.isAdmin
        @.loadingUsers = true
        @.$axios.get("users")
          .then (response) =>
            @.users = response.data
          .catch (error) => console.log('Could not update meal', error)
          .finally () => @.loadingUsers = false
      submit: ->
        @.loading = true
        params = Object.assign {}, @.mealLocal
        params = mapKeys(params, 'snakeCase')
        params = @._.pick(params, ['food_name', 'price', 'calorie_count', 'took_at', 'user_id'])
        if @.isEdit
          @.$axios.patch("meals/#{@.mealLocal.id}",params)
            .then (response) =>
              @.$emit 'update'
              @.closeModal()
              @.$notify({ title: 'Horray!', text: 'Meal Successfully Updated', type: 'success'})
            .catch (error) => console.log('Could not update meal', error)
            .finally () => @.loading = false
        else
          @.$axios.post('meals', params)
            .then (response) =>
              @.$emit 'add'
              @.closeModal()
              @.$notify({ title: 'Horray!', text: 'Meal Successfully Created', type: 'success'})
            .catch (error) => console.log('Could not create meal', error)
            .finally () => @.loading = false

  Mixin.components = { MealMaintModal }

  export default MealMaintModal

</script>

<style lang="sass" scoped>

</style>
