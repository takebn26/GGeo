class Building < ApplicationRecord

  after_validation :geocode

  def address
    [country, prefecture, city, detail_address].compact.join('')
  end

  private

  # TODO: エラー処理
  def geocode
    geocoded_info = Google::Geocoder.new(address).execute
    self.latitude = geocoded_info.lat
    self.longitude = geocoded_info.lng
  end
end
