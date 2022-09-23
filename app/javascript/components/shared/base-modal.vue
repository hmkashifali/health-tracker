<template lang="pug">
  modal(
    :adaptive="true"
    :classes="classes"
    :click-to-close="clickToClose"
    :focusTrap="true"
    :loading="loading"
    height="auto"
    :name="name"
    :scrollable="true"
    :styles="styles"
    @before-close="beforeClose"
    @before-open="beforeOpen"
  )
    v-card
      slot(name="header")
        v-card-title
          | {{ title }}
          v-card-actions.ml-auto
            v-btn(icon @click="closeModal")
              v-icon mdi-close

      slot(name="body")
      slot(name="footer")
        v-card-actions
          v-spacer
          v-btn(@click="closeModal" text) Close

</template>

<script lang="coffee">
  export default
    props:
      name:
        type: String
      classes:
        type: [Array, String]
        default: ''
      clickToClose:
        type: Boolean
        default: true
      loading:
        type: Boolean
        default: false
      styles:
        type: [Array, Object, String]
        default: ''
      title:
        type: String
        default: ''

    data: -> {}
    computed:
      extraClasses: ->
        classArray = []
        classArray.unshift(@.classes) if @.classes
        classArray.unshift('loading') if @.loading
        @._.flatten(classArray).join(' ')

    methods:
      beforeClose: (event)->
        @.$emit 'before-close', event

      beforeOpen: (event)->
        @.$emit 'before-open', event

      closeModal: ->
        @.$modal.hide @.name


</script>

<style lang="sass" scoped>

</style>
