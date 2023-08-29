class DataController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def create
    @datum = Datum.new(datum_params)
    if @datum.save
      notify_webhooks(@datum)
      render json: @datum, status: :created
    else
      render json: @datum.errors, status: :unprocessable_entity
    end
  end

  def update
    @datum = Datum.find(params[:id])
    if @datum.update(datum_params)
      notify_webhooks(@datum)
      render json: @datum
    else
      render json: @datum.errors, status: :unprocessable_entity
    end
  end

  private

  def datum_params
    params.require(:datum).permit(:name, :data)
  end

  def notify_webhooks(datum)
    # Iterate through configured third-party endpoints and send notifications
    webhook_urls = Rails.application.config.webhook_urls || []
    webhook_urls.each do |url|
      WebhookNotifier.send_notification(url, datum)
    end  
  end
end

