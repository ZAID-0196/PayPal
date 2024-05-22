PayPal::SDK.configure(
  mode: "sandbox", # or "live"
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET'],
  ssl_options: { ca_file: nil }
)
PayPal::SDK.logger = Rails.logger
