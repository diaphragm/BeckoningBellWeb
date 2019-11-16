class MaintenanceController < ApplicationController
  before_action :basic
  protect_from_forgery with: :exception

  def cleanup
    items = []

    Bell.expired.each do |bell|
      if bell.delete_logical
        ActionCable.server.broadcast("room_#{bell.id}", {deleted: true})
        Twitter::CLIENT.destroy_status(bell.tweet_uri)
        logger.info("cleanup #{bell}")
        items << bell
      end
    end

    render json: items
  end

  private

  def basic
    authenticate_or_request_with_http_basic do |name, password|
      name == Rails.application.credentials.admin[:user] \
      && password == Rails.application.credentials.admin[:password]
    end
  end

end