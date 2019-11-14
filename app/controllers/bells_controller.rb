class BellsController < ApplicationController
  def show
    @bell = Bell.availables.find(params[:id])

    if request.format == :json
      render json: @bell
    end
  end

  def new
    @bells = Bell.availables.all
  end

  def create
    @bell = Bell.new(bell_params)

    if @bell.save
      session[@bell.id.to_s] = {"user" => BloodborneUtils.host_name}

      redirect_to @bell
    end
  end

  def update
    @bell = Bell.availables.find(params[:id])

    session[@bell.id.to_s]
    BloodborneUtils.host_name

    return unless session[@bell.id.to_s]["user"] == BloodborneUtils.host_name

    if @bell.update(bell_params)
      ActionCable.server.broadcast("room_#{@bell.id}", @bell)
      render json: @bell
    end
  end

  def destroy
    @bell = Bell.availables.find(params[:id])
    return unless session[@bell.id.to_s]["user"] == BloodborneUtils.host_name

    if @bell.delete_logical
      ActionCable.server.broadcast("room_#{@bell.id}", {deleted: true})
      render json: @bell
    end
  end

  private

  def bell_params
    data = params.require(:bell).permit(:place_id, :password, :note)
    ret = {}
    ret[:place] = BloodborneUtils.find_place(data[:place_id])
    ret[:password] = data[:password]
    ret[:note] = data[:note]
    ret
  end
end
