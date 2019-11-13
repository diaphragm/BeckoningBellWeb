import Vue from 'vue/dist/vue.esm'
import { csrfToken } from '@rails/ujs'

import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import lang from 'element-ui/lib/locale/lang/ja'
import locale from 'element-ui/lib/locale'
locale.use(lang)
Vue.use(ElementUI)

document.addEventListener('turbolinks:load', async () => {
  const CsrfToken = csrfToken()

  const fetchBell = async (data) => {
    return fetch(IV.bellUrl, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": CsrfToken
      },
      body: JSON.stringify({
        place: data.place,
        password: data.password,
        note: data.note
      })
    })
  }


  new Vue({
    el: '#app-new',
    data: {
      form: {},
      disable: false
    },
    methods: {
      onSubmit: async function() {
        this.disable = true
        let res = await fetchBell(this.form)
        window.res = res
        if (res.ok) {
          Turbolinks.visit(res.url)
        } else {
          console.log('err')
        }
        this.disable = false
      }
    }
  })
})

// in
