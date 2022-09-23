<template lang="pug">
  .stats
    admin-stats(v-if="currentUser.isAdmin")
    non-admin-stats(v-else)
</template>

<script lang="coffee">
  import AdminStats from 'components/stats/admin-stats'
  import { mapState } from 'vuex'
  import NonAdminStats from 'components/stats/non-admin-stats'
  export default
    data: -> {}
    computed: Object.assign {}, mapState({ 'currentUser' })
    components: { AdminStats, NonAdminStats }

</script>

<style lang="sass" scoped>
</style>
