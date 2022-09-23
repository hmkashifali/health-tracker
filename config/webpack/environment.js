const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')

const coffee = require('./loaders/coffee')
const less = require('./loaders/less')
const pug = require('./loaders/pug')
const sass = require('./loaders/sass')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('coffee', coffee)
environment.loaders.prepend('less', less)
environment.loaders.prepend('pug', pug)
environment.loaders.prepend('sass', sass)
environment.loaders.prepend('vue', vue)

environment.config.merge({
  resolve: {
    alias: {
      vue$: 'vue/dist/vue.esm.js'
    }
  }
});
module.exports = environment
