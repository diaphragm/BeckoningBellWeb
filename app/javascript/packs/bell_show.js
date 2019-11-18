require("channels")

import Vue from 'vue/dist/vue.esm'
import { csrfToken } from '@rails/ujs'

import ElementUI from 'element-ui'
Vue.use(ElementUI)

document.addEventListener('DOMContentLoaded', async () => {
  const CsrfToken = csrfToken()

  window.MessageList = (await (await fetch(IV.messagesUrl )).json()).reverse()

  let smKey = 0
  const sendSystemMessage = (message) => {
    MessageList.unshift({
      id: 'sytem' + smKey++,
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
        "X-CSRF-Token": CsrfToken,
        'X-Requested-With': 'XMLHttpRequest'
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
    props: ['group'],
    data: function () {
      return { items: IV.chatStampList[this.group] }
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
      configFormRules: {
        place: [
          { required: true, message: '鐘を鳴らしている場所を選択してください', trigger: 'chanege' }
        ],
        password: [
          { required: true, message: '合言葉を入力してください', trigger: 'blur' },
          { max: 20, message: '合言葉は20文字以内にしてください', trigger: 'blur' }
        ],
        note: [
          { max: 200, message: '備考は200文字以内にしてください', trigger: 'blur' }
        ]
      },
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
            募集は終了しました。お疲れ様でした。
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
        this.$refs['config'].validate(async (valid) => {
          if (valid) {
            this.configOpen = false
            let placeId = IV.placeReverseData[this.configFormData.place]
            await updateBell(placeId, this.configFormData.password, this.configFormData.note)
          }
        })
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
      },
      moveTop: function() {
        this.$confirm('募集中の鐘一覧からまた戻ることもできます。', 'トップページに移動しますか？', {
          confirmButtonText: 'はい',
          cancelButtonText: 'いいえ',
        }).then( () => {
          location.href = '/'
        })
      }
    }
  })

  if (IV.user == "狩りの主") {
    sendSystemMessage(`
      右上のボタンから募集を終了したり、鐘の情報を更新することができます。<br>
      募集は一定時間で自動的に終了しますが、他の協力者のためにも協力プレイを終える際には手動で募集を終了するようご協力をお願いします。
    `)
  }
  sendSystemMessage(`
    狩人呼びの鐘Webへようこそ。下部にあるボタンから、定型文やスタンプを送信できます。
    ホスト(狩りの主)以外のユーザー名は、自動でランダムに選ばれます。
  `)
})
