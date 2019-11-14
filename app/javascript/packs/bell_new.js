import Vue from 'vue/dist/vue.esm'
import { csrfToken } from '@rails/ujs'

import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import lang from 'element-ui/lib/locale/lang/ja'
import locale from 'element-ui/lib/locale'
locale.use(lang)
Vue.use(ElementUI)

document.addEventListener('DOMContentLoaded', async () => {
  const CsrfToken = csrfToken()

  const fetchAPI = async (url, method, data) => {
    return fetch(url, {
      method: method,
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": CsrfToken
      },
      body: JSON.stringify(data)
    })
  }

  const fetchBell = async (data) => {
    return fetchAPI(IV.bellUrl, 'POST', {
        place: data.place,
        password: data.password,
        note: data.note
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
          document.location.href = res.url
        } else {
          console.log('err')
        }
        this.disable = false
      },
      deleteBell: function(path) {
        this.$confirm('募集を終了してよろしいですか？', '共鳴破りの空砲', {
          confirmButtonText: 'はい',
          cancelButtonText: 'いいえ',
          type: 'warning'
        }).then(async () => {
          await fetchAPI(path, 'DELETE')
          location.reload()
        })
      }
    }
  })
})

// in
