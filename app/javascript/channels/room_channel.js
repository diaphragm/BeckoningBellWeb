import consumer from "./consumer"

document.addEventListener('DOMContentLoaded', function () {
  consumer.subscriptions.create({ channel: "RoomChannel", bell_id: IV.bell.id}, {
    connected() {
      // Called when the subscription is ready for use on the server
      // console.log("Connected to Room!")
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      // console.log("Disconnected from Room...")
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      IV.bell = data
    }
  })
})
