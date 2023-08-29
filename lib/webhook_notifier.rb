class WebhookNotifier
  def self.send_notification(url, datum)
    # Send HTTP POST request to webhook URL with data
    # Implement the sending logic using libraries like RestClient or HTTParty
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
