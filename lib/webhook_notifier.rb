require 'rest-client'
class WebhookNotifier
  def self.send_notification(url, datum)
    begin
      response = RestClient.post(url, data.to_json, headers: { content_type: :json, accept: :json })

      if response.code == 200
        # Successfully sent the notification
        return true
      else
        # Handle the case where the webhook endpoint returned an unexpected status code
        Rails.logger.error("Webhook request failed with status code #{response.code}")
        return false
      end
      rescue RestClient::ExceptionWithResponse => e
      # Handle RestClient errors (e.g., connection errors, timeout)
      Rails.logger.error("RestClient error: #{e.message}")
      return false
    rescue StandardError => e
      # Handle other errors
      Rails.logger.error("Error: #{e.message}")
      return false
    end
  end

  def self.verify_request(headers, body)
    # Get the shared secret key from your Rails app's configuration
    shared_secret = Rails.application.config.webhook_shared_secret
    
    # Get the payload from the request body
    payload = request.body.read
    
    # Get the received hash from the headers or parameters (depends on third-party's approach)
    received_hash = request.headers['X-Webhook-Hash'] || params['webhook_hash']
    
    # Calculate the expected hash using the shared secret and the payload
    expected_hash = OpenSSL::HMAC.hexdigest('sha256', shared_secret, payload)
    
    # Compare the expected hash with the received hash
    if ActiveSupport::SecurityUtils.secure_compare(received_hash, expected_hash)
      # Hashes match, the request is authentic
      # Process the payload
      #################
      head :ok
    else
      # Hashes don't match, the request is not authentic
      head :unauthorized
    end
  end
end
