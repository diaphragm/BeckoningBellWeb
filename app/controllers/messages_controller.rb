class MessagesController < ApplicationController
  def index
    bell = Bell.find(params[:bell_id])
    messages = bell.messages.all
    render json: messages
  end

  def show
    message = Message.find(params[:id])
    if message.bell_id == params[:bell_id]
      render json: message
    else
      render status: 404, json: {status: 404, message: "Message Not Found"}
    end
  end

  def create
    @bell = Bell.find(params[:bell_id])

    unless session.dig(@bell.id.to_s, "user")
      existing_users = @bell.messages.map{|m| m.user}.uniq
      session[@bell.id.to_s] = {"user" => BloodborneUtils.generate_hunter_name(existing_users)}
    end
    p user = session[@bell.id.to_s]["user"]
    new_message = {user: user}

    new_message[:text] = case sended_params[:type]
    when "text"
      BloodborneUtils.find_message(sended_params["value"])
    when "stamp"
      image = "stamps/" + BloodborneUtils.find_stamp(sended_params["value"])
      %[<img class="stamp" src="#{view_context.image_path(image)}">]
    end

    @message = @bell.messages.new(new_message)

    if @message.save
      ActionCable.server.broadcast("bell_#{@bell.id}", @message)
      render json: @message
    end
  end

  private

  def sended_params
    params.require(:message).permit(:type, :value)
  end
end
