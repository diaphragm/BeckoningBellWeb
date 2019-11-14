class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params["bell_id"]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
