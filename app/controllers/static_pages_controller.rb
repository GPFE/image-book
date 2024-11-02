class StaticPagesController < ApplicationController
  def index
    if params[:user_id]
      @user_photos = get_photo_urls(params[:user_id])
    end
  end

  private

  def get_photo_urls(user_id)
    api_key = Rails.application.credentials.dig(:flickr, :api_key)
    photo_urls = []
    get_photo_ids(user_id).each do |photo_id|
      url = "https://www.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=#{api_key}&photo_id=#{photo_id}&format=json&nojsoncallback=1"
      response = HTTParty.get(url)
      photo_urls << response["sizes"]["size"][5]["source"]
    end
    photo_urls
  end

  def get_photo_ids(user_id)
    api_key = Rails.application.credentials.dig(:flickr, :api_key)
    url = "https://api.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=#{api_key}&user_id=#{user_id}&format=json&nojsoncallback=1"
    response = HTTParty.get(url)
    photo_ids = []
    photos_info = response["photos"]["photo"]
    photos_info.each do |photo_info|
      photo_info.each do |key, value|
        if key == "id"
          photo_ids << value
          next
        end
      end
    end
    photo_ids
  end
end
