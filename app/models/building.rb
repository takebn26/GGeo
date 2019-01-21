class Building < ApplicationRecord

  before_create :geocode
  before_update :re_geocode

  private

  # TODO: エラー処理
  def geocode
    Google::Geocoder.new(self).geocode do |geocoded_info|
      self.latitude  = geocoded_info.latlng[:lat]
      self.longitude = geocoded_info.latlng[:lng]
    end
  end

  def re_geocode
    Google::Geocoder.new(self).re_geocode do |geocoded_info|
      self.address = geocoded_info.full_address
    end
  end
end
