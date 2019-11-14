import consumer from "./consumer"

document.addEventListener('DOMContentLoaded', function () {
  consumer.subscriptions.create({ channel: "RoomChannel", bell_id: IV.bell.id}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("connected room!")
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log("disconnected room...")
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      IV.bell = data
    }
  })
})
