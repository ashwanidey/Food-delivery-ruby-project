require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module FoodDelivery
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Add app/api to the eager load paths
    config.eager_load_paths << Rails.root.join('app', 'api')

    config.paths.add 'app/api', eager_load: true

  end
end
