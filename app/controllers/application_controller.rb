class ApplicationController < ActionController::Base
  rescue_from Exception, with: :_render_500 unless Rails.env.development?

  rescue_from ActionController::RoutingError, with: :_render_404
  rescue_from ActiveRecord::RecordNotFound, with: :_render_404
  rescue_from Twitter::Error, with: :_render_twitter_error

  def _render_404(e = nil)
    logger.info(e)

    if request.xhr?
      render status: 404, json: { status: 404 }
    else
      render 'errors/404', status: 404, layout: false
    end
  end

  def _render_500(e = nil)
    logger.info(e)

    if request.xhr?
      render status: 500, json: { status: 500 }
    else
      render 'errors/500', status: 500
    end
  end

  def _render_twitter_error(e = nil)
    render status: 500, json: { status: 500, message: 'Twitter error'}
  end
end
