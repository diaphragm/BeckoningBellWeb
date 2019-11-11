import consumer from "./consumer"

window.addEventListener('load', function() {
  let bell_id = document.getElementById('bell-id').getAttribute('data-bell-id')

  const chatChannel = consumer.subscriptions.create({channel: "ChatChannel", bell_id: bell_id}, {
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

      let message = data.user + ":" + data.text + '<span data-behavior="time-ago" data-content="' + data.created_at + '"></span>'
      console.log(message)
      let elem_message = document.createElement("p")
      elem_message.className = "message"
      // elem_message.appendChild(document.createElement(message))
      elem_message.innerHTML = message
      let elem_view = document.getElementById("viewer")
      elem_view.insertBefore(elem_message, elem_view.firstChild)

      updateTime()
    },

    // Action Cableだとセッション使えないのでpostはajaxで
    post(data) {
      console.log("post")
      return this.perform("post", data)
    }
  })

  // let el_text = document.querySelector("[data-behavior=chat-text]")
  // let el_button = document.querySelector("[data-behavior=chat-send]")
  // el_button.addEventListener("click", () => {
  //   console.log("ho")
  //   chatChannel.post({text: el_text.value})
  //   el_text.value = ""
  // })


  // window.onclick = function() {chatChannel.post({message: "ほげ"}) }
})
