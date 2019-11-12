import consumer from "./consumer"

document.addEventListener('DOMContentLoaded', function() {
  const chatChannel = consumer.subscriptions.create({channel: "ChatChannel", bell_id: IV.bellId}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("Connected!")
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log("Disconnected...")
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log("Receiving:")
      console.log(data)
      MessageList.push(data)
    },

    // Action Cableだとセッション使えないのでpostはajaxで
    post(data) {
      console.log("post")
      return this.perform("post", data)
    }
  })
})
