class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bell_#{params["bell_id"]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def post(data)
    ActionCable.server.broadcast("bell_#{params["bell_id"]}", data)
  end
end
