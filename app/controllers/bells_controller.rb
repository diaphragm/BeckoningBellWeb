class BellsController < ApplicationController
  def index
    @bells = Bell.all
    if request.format == :json
      render json: @bells
    end
  end

  def show
    @bell = Bell.find(params[:id])

    if request.format == :json
      render json: @bell
    end
  end

  def new
    @bells = Bell.all
  end

  def create
    tmp = bell_params
    tmp[:place] = BloodborneUtils.find_place(tmp[:place])
    @bell = Bell.new(tmp)

    if @bell.save
      session[@bell.id.to_s] = {"user" => BloodborneUtils.host_name}

      redirect_to @bell
    else
      render plain: "err"
    end
  end

  def update
    @bell = Bell.find(params[:id])
    @bell.update(bell_params)
    redirect_to @bell
  end

  private

  def bell_params
    params.require(:bell).permit(:place, :password, :note)
  end
end
