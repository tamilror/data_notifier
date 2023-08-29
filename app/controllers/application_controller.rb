class ApplicationController < ActionController::Base
before_action :verify_webhook_authenticity

  def verify_webhook_authenticity
    unless WebhookNotifier.verify_request(request.headers, request.raw_post)
      render plain: "Unauthorized", status: :unauthorized
    end
  end
end
