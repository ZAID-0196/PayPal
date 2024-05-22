require "net/http"

class PayPalService
  def get_access_token
    url = URI(ENV['BASE_URL'] + '/v1/oauth2/token')
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request["Authorization"] = "Basic #{get_authorization_header}"
    request.body = "grant_type=client_credentials"
    response = https.request(request)
    response_body = JSON.parse(response.read_body)
    response_body.dig('access_token')
  end

  def payment_create(recipient_email, amount, currency, description)
    url = URI(ENV['BASE_URL'] + '/v1/payments/payment')
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{get_access_token}"
    request.body = JSON.dump({
      "intent": "sale",
      "payer": {
        "payment_method": "paypal"
      },
      "redirect_urls": {
        "return_url": ENV["RETURN_URL"].presence || "https://example.com/return",
        "cancel_url": ENV["CANCEL_URL"].presence || "https://example.com/cancel"
      },
      "transactions": [
        {
          "amount": {
            "total": amount.to_s,
            "currency": currency.to_s
          },
          "description": description.to_s
        }
      ]
    })
    response = https.request(request)
    response_body = JSON.parse(response.read_body)
    response_body
  end

  def payment_payout(recipient_email, amount, currency, description)
    url = URI(ENV['BASE_URL'] + '/v1/payments/payouts')
    sender_batch_id = SecureRandom.hex(8)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{get_access_token}"
    request.body = JSON.dump({
      "sender_batch_header": {
        "sender_batch_id": "#{sender_batch_id}",
        "email_subject": "Your payout from MyApp"
      },
      "items": [
        {
          "recipient_type": "EMAIL",
          "amount": {
            "value": amount.to_s,
            "currency": currency.to_s
          },
          "note": note.to_s,
          "receiver": recipient_email.to_s
        }
      ]
    })

    response = https.request(request)
    response_body = JSON.parse(response.read_body)
    response_body
  end

  def handle_payment_return_url(payment_id)
    url = URI(ENV['BASE_URL'] + "/v1/payments/payment/#{payment_id}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{get_access_token}"
    response = https.request(request)
    response_body = JSON.parse(response.read_body)
    response_body
  end

  def execute_payment(payment_id, payer_id)
    url = URI(ENV['BASE_URL'] + "/v1/payments/payment/#{payment_id}/execute")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{get_access_token}"
    request.body = JSON.dump({
      "payer_id": "#{payer_id}"
    })

    response = https.request(request)
    response_body = JSON.parse(response.read_body)
    response_body
  end

  private

  def get_authorization_header
    Base64.strict_encode64("#{ENV['PAYPAL_CLIENT_ID']}:#{ENV['PAYPAL_CLIENT_SECRET']}")
  end
end
