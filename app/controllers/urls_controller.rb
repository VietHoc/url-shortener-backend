class UrlsController < ApplicationController
  before_action :set_url, only: [:show]
  before_action :set_url_by_short_url_params, only: [:decode]

  def show
    redirect_to(@url.original_url, allow_other_host: true)
  end

  def encode
    @url = Url.find_or_create_by(url_params)
    if @url.persisted?
      render json: { short_url: get_short_url }
    else
      render json: { errors: @url.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def decode
    render json: { original_url: @url.original_url }
  end

  private

  def set_url
    @url = Url.find_by(short_url: params[:id])
    render json: { error: "Short URL not found" }, status: :not_found unless @url
  end

  def url_params
    params.require(:url).permit(:original_url, :short_url)
  end

  def get_short_url
    "#{request.base_url}/#{@url.short_url}"
  end

  def set_url_by_short_url_params
    short_url = url_params[:short_url].split('/').last
    @url = Url.find_by_short_url(short_url)
    render json: { error: "Short URL not found" }, status: :not_found unless @url
  end
end
