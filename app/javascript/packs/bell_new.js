import Vue from 'vue/dist/vue.esm'
import { csrfToken } from '@rails/ujs'

import ElementUI from 'element-ui'
// import 'element-ui/lib/theme-chalk/index.css'
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
        "X-CSRF-Token": CsrfToken,
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: JSON.stringify(data)
    })
  }

  const fetchBell = async (data) => {
    return fetchAPI(IV.bellUrl, 'POST', {
      bell: {
        place_id: data.placeId,
        password: data.password,
        note: data.note
      }
    })
  }

  new Vue({
    el: '#app-new',
    data: {
      form: {},
      rules: {
        placeId: [
          { required: true, message: '鐘を鳴らしている場所を選択してください', trigger: 'chanege'}
        ],
        password: [
          { required: true, message: '合言葉を入力してください', trigger: 'blur'},
          { max: 20, message: '合言葉は20文字以内にしてください', trigger: 'blur'}
        ],
        note: [
        { max: 200, message: '合言葉は200文字以内にしてください', trigger: 'blur'}
        ],
      },
      disable: false
    },
    methods: {
      onSubmit: async function() {
        this.$refs['form'].validate(async (valid) => {
          if (valid) {
            this.disable = true
            let res = await fetchBell(this.form)
            if (res.ok) {
              document.location.href = res.url
            }
            this.disable = false
          }
        })
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
