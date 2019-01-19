require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GeoPra
  class Application < Rails::Application
    config.load_defaults 5.2
    config.eager_load_paths += %w[
      lib/app
    ].map { |path| "#{config.root}/#{path}" }
  end
end
