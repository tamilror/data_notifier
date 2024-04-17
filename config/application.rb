require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DataNotifier
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
   # Configure third-party API endpoints
    config.third_party_endpoints = [
      'https://example.com/api/endpoint1',
      'https://another-example.com/api/endpoint2'
      # Add more endpoints as needed
    ]  
end
def notify_webhooks(datum)
  webhook_urls = Rails.application.config.webhook_urls || []
  webhook_urls.each do |url|
    WebhookNotifier.send_notification(url, datum)
  end  
end

end
