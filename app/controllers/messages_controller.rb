class MessagesController < ApplicationController
  def create

    @bell = Bell.find(params[:bell_id])

    unless session.dig(@bell.id.to_s, "user")
      existing_users = @bell.messages.map{|m| m.user}.uniq
      session[@bell.id.to_s] = {"user" => BloodborneUtil.generate_hunter_name(existing_users)}
    end
    p user = session[@bell.id.to_s]["user"]

    tmp_message = message_params.merge("user" => user)
    tmp_message["text"] = BloodborneUtil.find_message(tmp_message["text"])

    p tmp_message

    @message = @bell.messages.new(tmp_message)

    if @message.save
      ActionCable.server.broadcast("bell_#{@bell.id}", @message)
    end

    render "bells/show"
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end
end
