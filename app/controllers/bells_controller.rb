class BellsController < ApplicationController
  def show
    @bell = Bell.available.find(params[:id])

    if request.format == :json
      render json: @bell
    end
  end

  def new
    @bells = Bell.available.all
  end

  def create
    @bell = Bell.new(bell_params)

    if @bell.save
      session[@bell.id.to_s] = {"user" => BloodborneUtils.host_name}

      redirect_to @bell

      tweet = %[#{@bell.place}で鐘鳴らしてます。#{url_for(@bell)}\n#{@bell.note}][0..139].chomp
      res = Twitter::CLIENT.update!(tweet)
      @bell.update(tweet_uri: res.uri)
    end
  end

  def update
    @bell = Bell.available.find(params[:id])

    session[@bell.id.to_s]
    BloodborneUtils.host_name

    return unless session[@bell.id.to_s]["user"] == BloodborneUtils.host_name

    if @bell.update(bell_params)
      ActionCable.server.broadcast("room_#{@bell.id}", @bell)
      render json: @bell

      tweet = %[【更新】 #{@bell.place}で鐘鳴らしてます。#{url_for(@bell)}\n#{@bell.note}][0..139].chomp \
            + ' ' + @bell.tweet_uri.to_s
      res = Twitter::CLIENT.update!(tweet, in_reply_to_status_id: @bell.tweet_uri[/\d+$/])
      @bell.update(tweet_uri: res.uri)
    end
  end

  def destroy
    @bell = Bell.available.find(params[:id])
    return unless session[@bell.id.to_s]["user"] == BloodborneUtils.host_name

    if @bell.delete_logical
      ActionCable.server.broadcast("room_#{@bell.id}", {deleted: true})

      # Twitter::CLIENT.destroy_status(@bell.tweet_uri)
      tweet = %[【終了】募集は終了しました。 ] + @bell.tweet_uri.to_s
      Twitter::CLIENT.update!(tweet, in_reply_to_status_id: @bell.tweet_uri[/\d+$/])

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
