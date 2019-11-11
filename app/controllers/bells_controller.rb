class BellsController < ApplicationController
  def show
    @bell = Bell.find(params[:id])

    existing_users = @bell.messages.map{|m| m.user}.uniq
    # session[@bell.id.to_s] ||= {"user" => BloodborneUtil.generate_hunter_name(existing_users)}

  rescue ActiveRecord::RecordNotFound
    render plain: "err"
  end

  def new
  end

  def create
    @bell = Bell.new(bell_params)

    if @bell.save
      session[@bell.id.to_s] = {"user" => "狩りの主"}

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
