# TODO: エラー処理
module Google
  GOOGLE_URL = 'https://maps.googleapis.com'.freeze

  class Geocoder
    GEOCODE_ENDPOINT = '/maps/api/geocode/json'.freeze

    attr_reader :latlng, :full_address

    def initialize(place)
      @place = place
    end

    def geocode
      res = connection.get do |req|
        req.url GEOCODE_ENDPOINT, address_param
      end

      geocoded_parse(res.body)

      yield self
    end

    def re_geocode
      res = connection.get do |req|
        req.url GEOCODE_ENDPOINT, latlng_param
      end

      re_geocoded_parse(res.body)

      yield self
    end

    private

    def connection
      @connection ||= Faraday.new(GOOGLE_URL) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end

    def address_param
      { key: ENV['GAK'], address: @place.address }
    end

    def latlng_param
      {
        key: ENV['GAK'],
        latlng: [@place.latitude, @place.longitude].join(','),
        language: 'ja'
      }
    end

    def geocoded_parse(res)
      body = JSON.parse(res)

      @latlng = {
        lat: body['results'][0]['geometry']['location']['lat'],
        lng: body['results'][0]['geometry']['location']['lng']
      }
    end

    def re_geocoded_parse(res)
      body = JSON.parse(res)

      @full_address = body["results"][0]["formatted_address"]
    end
  end
end