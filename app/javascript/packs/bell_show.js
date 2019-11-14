require("channels")

import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'
import { csrfToken } from '@rails/ujs'

import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
Vue.use(ElementUI)

document.addEventListener('DOMContentLoaded', async () => {
  const CsrfToken = csrfToken()

  window.MessageList = (await (await fetch(IV.messagesUrl )).json()).reverse()

  const sendSystemMessage = (message) => {
    MessageList.unshift({
      id: 'sytem-init',
      text: message,
      created_at: (new Date()).getTime()
    })
  }

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

  const postMessage = async (type, value) => {
    let data = {
      message: {
        type: type,
        value: value
      }
    }
    return fetchAPI(IV.messagesUrl , 'POST', data)
  }

  const updateBell = async (placeId, password, note) => {
    let data = {
      bell: {
        place_id: placeId,
        password: password,
        note: note
      }
    }
    return fetchAPI(IV.bellUrl , 'PATCH', data)
  }

  const destroyBell = async () => {
    return fetchAPI(IV.bellUrl, 'DELETE')
  }

  const ChatSelectText = ({
    props: ['group'],
    data: function() {
      return {items: IV.chatTextList[this.group]}
    },
    methods: {
      onclick: async function(id) {
        let res = await postMessage('text', id)
        if (res.ok) {
          IV.user = (await res.json()).user
        }
      }
    },
    template: `
      <div class="chat-legend-container">
        <el-button class="text-legend"
          v-for="item in items"
          v-bind:key="item.id"
          v-on:click="onclick(item.id)"
        >{{ item.text }}</el-button>
      </div>
      `
  })

  const ChatSelectStamp = ({
    data: function () {
      return { items: IV.chatStampList }
    },
    methods: {
      onclick: async function (id) {
        let res = await postMessage('stamp', id)
        if (res.ok) {
          IV.user = (await res.json()).user
        }
      }

    },
    template: `
      <div class="chat-legend-container">
        <el-button class="stamp-legend"
          v-for="item in items"
          v-bind:key="item.id"
          v-on:click="onclick(item.id)"
        ><img v-bind:src="item.text"></el-button>
      </div>
      `
  })

  const TimeAgo = {
    props: ['time'],
    template: `<span>{{timeAgo}}</span>`,
    data: function() {
      return {timeAgo: ''}
    },
    created: function() {
      this.calcTimeAgo()
      setInterval(this.calcTimeAgo, 5*1000)
    },
    methods: {
      calcTimeAgo: function() {
        let now = new Date()
        let date = new Date(this.time)
        let diff = new Date(Math.max(now.getTime() - date.getTime(), 0))

        if (diff.getUTCFullYear() - 1970) {
          this.timeAgo = diff.getUTCFullYear() - 1970 + 'y'
        } else if (diff.getUTCMonth()) {
          this.timeAgo = diff.getUTCMonth() + 'mom'
        } else if (diff.getUTCDate() - 1) {
          this.timeAgo = diff.getUTCDate() - 1 + 'd'
        } else if (diff.getUTCHours()) {
          this.timeAgo = diff.getUTCHours() + 'h'
        } else if (diff.getUTCMinutes()) {
          this.timeAgo = diff.getUTCMinutes() + 'm'
        } else {
          if (diff.getUTCSeconds() >= 20) {
            this.timeAgo = Math.floor(diff.getUTCSeconds() / 10)*10 + 's'
          } else {
            this.timeAgo = 'now'
          }
        }
      }
    }
  }

  const ChatMessage = {
    props: ['message', 'user'],
    template: `
      <div>
        <template v-if="message.user == user">
          <div class="message-container message-own">
          <span class="message-user">{{ message.user }}</span>
          <span class="message-time">(<time-ago v-bind:time="message.created_at"></time-ago>)</span>
          <span class="message-text" v-html="message.text"></span>
          </div>
        </template>
        <template v-else>
          <div class="message-container">
            <span class="message-user">{{ message.user }}</span>
            <span class="message-text" v-html="message.text"></span>
            <span class="message-time">(<time-ago v-bind:time="message.created_at"></time-ago>)</span>
          </div>
        </template>
      </div>
    `,
    components: {
      'time-ago': TimeAgo
    }
  }

  new Vue({
    el: '#app-show',
    data: {
      iv: window.IV,
      messages: MessageList,
      infoPop: false,
      configOpen: false,
      configFormData: Object.assign({}, IV.bell),
      configButtonDisable: false,
      blankShotButtonDisable: false,
    },
    components: {
      'chat-message': ChatMessage,
      'chat-select-text': ChatSelectText,
      'chat-select-stamp': ChatSelectStamp
    },
    mounted: function() {
      this.infoPop = true
    },
    watch: {
      'iv.bell': function() {
        if( IV.bell.deleted) {
          this.$message({
            message: '鐘の共鳴が破れました。',
            type: 'warning'
          })
          sendSystemMessage(`
            お疲れ様でした。ホストにより募集が終了しました。
            <a href="/" class="el-link el-link--default is-underline">TOPに戻る</a>
          `)
        } else {
          this.configFormData = Object.assign({}, IV.bell)
          this.$message('鐘の情報が更新されました。')
          this.infoPop = true
        }
      }
    },
    methods: {
      configChange: async function() {
        this.configOpen = false
        let placeId = IV.placeReverseData[this.configFormData.place]
        await updateBell(placeId, this.configFormData.password, this.configFormData.note)
      },
      blankShot: async function() {
        this.$confirm('募集を終了してよろしいですか？', '共鳴破りの空砲',{
          confirmButtonText: 'はい',
          cancelButtonText: 'いいえ',
          type: 'warning'
        }).then(async () => {
            this.configOpen = false
            await destroyBell()
        })
      }
    }
  })

  sendSystemMessage(`
    狩人呼びの鐘Webへようこそ。下部にあるボタンから、定型文やスタンプを送信できます。
    ホスト(狩りの主)以外のユーザー名は、自動でランダムに選ばれます。
  `)
})
