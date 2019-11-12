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

  const ChatSelectText = ({
    data: function() {
      return {items: ChatTextList}
    },
    methods: {
      onclick: function(id) {
        postMessage('text', id)
      }
    },
    template: `
      <div>
        <div class=text-legend
          v-for="item in items"
          v-bind:key="item.id"
          v-on:click="onclick(item.id)"
        >{{ item.text }}</div>
      </div>
      `
  })

  const ChatSelectStamp = ({
    data: function () {
      return { items: ChatStampList }
    },
    methods: {
      onclick: function (id) {
        postMessage('stamp', id)
      }
    },
    template: `
      <div>
        <img class=stamp-legend
          v-for="item in items"
          v-bind:key="item.id"
          v-on:click="onclick(item.id)"
          v-bind:src="item.text"
        >
      </div>
      `
  })

  new Vue({
    el: '#chat-input',
    data: {
      type: 'text'
    },
    components: {
      'chat-select-text': ChatSelectText,
      'chat-select-stamp': ChatSelectStamp
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
