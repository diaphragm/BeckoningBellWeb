class BellsController < ApplicationController
  def show
    @bell = Bell.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render plain: "err"
  end

  def new
  end

  def create
    @bell = Bell.new(bell_params)

    if @bell.save
      redirect_to @bell
    else
      render plain: "err"
    end
  end

  private

  def bell_params
    params.require(:bell).permit(:place, :password, :note)
  end

end
