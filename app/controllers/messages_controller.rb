class MessagesController < ApplicationController
  def create
    @bell = Bell.find(params[:bell_id])
    @message = @bell.messages.new(message_params)

    @message.save

    redirect_to @bell
  end

  private

  def message_params
    params.require(:message).permit(:user, :text)
  end
end
