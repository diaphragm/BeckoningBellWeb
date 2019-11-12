import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'
import { csrfToken } from '@rails/ujs'

document.addEventListener('DOMContentLoaded', async () => {
  window.MessageList = await (await fetch(ChatUrl)).json()

  const CsrfToken = csrfToken()

  const postMessage = async (type, value) => {
    fetch(ChatUrl, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": CsrfToken
      },
      body: JSON.stringify({
        message: {
          type: type,
          value: value
        }
      })
    })
  }

  new Vue({
    el: '#chat-select-text',
    data: {
      items: ChatTextList,
    },
    methods: {
      onclick: function(id) {
        postMessage('text', id)
      }
    }
  })

  new Vue({
    el: '#chat-select-stamp',
    data: {
      items: ChatStampList,
    },
    methods: {
      onclick: function(id) {
        postMessage('stamp', id)
      }
    }
  })

  const ChatMessage = {
    props: ['message'],
    template: `
      <div>
        {{ message.user }}: <span v-html="message.text"></span> ({{ message.created_at }})
      </div>
    `
  }

  new Vue({
    el: '#chat-viewer',
    data: {
      messages: MessageList
    },
    components: {
      'chat-message': ChatMessage
    }
  })

})
