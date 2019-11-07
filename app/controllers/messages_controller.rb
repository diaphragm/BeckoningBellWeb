class MessagesController < ApplicationController
  def create

    @bell = Bell.find(params[:bell_id])
    user = session[@bell.id.to_s]["user"]
    @message = @bell.messages.new(message_params.merge("user" => user))

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
