import Vue from 'vue/dist/vue.esm'
import { csrfToken } from '@rails/ujs'

import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
Vue.use(ElementUI)

document.addEventListener('turbolinks:load', async () => {
  new Vue({
    el: '#app-index'
  })
})
