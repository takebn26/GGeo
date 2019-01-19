# TODO: エラー処理
module Google
  GOOGLE_URL = 'https://maps.googleapis.com'.freeze

  class Geocoder
    GEOCODER_ENDPOINT = '/maps/api/geocode/json'.freeze

    attr_accessor :lat, :lng

    def initialize(address)
      @address = address
    end

    def execute
      res = connection.get do |req|
        req.url GEOCODER_ENDPOINT, parameters
      end

      body_parse(res.body)

      self
    end

    private

    def connection
      @connection ||= Faraday.new(GOOGLE_URL) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end

    def parameters
      { key: ENV['GAK'], address: @address }
    end

    def body_parse(res)
      body = JSON.parse(res)

      @lat = body['results'][0]['geometry']['location']['lat']
      @lng = body['results'][0]['geometry']['location']['lng']

      true
    end
  end
end