class MessagesController < ApplicationController
  def create

    @bell = Bell.find(params[:bell_id])
    user = session[@bell.id.to_s]["user"]
    @message = @bell.messages.new(message_params.merge("user" => user))

    @message.save

    redirect_to @bell
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end
end
