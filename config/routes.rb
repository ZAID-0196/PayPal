Rails.application.routes.draw do
  root "pay_pals#index"
  post "process_payment", to: "pay_pals#process_payment"
  post "paypal_payment_execute", to: "pay_pals#paypal_payment_execute"
  get "payment_return", to: "pay_pals#payment_return"
  get "cancel", to: "pay_pals#cancel"
  post "send_payout", to: "pay_pals#send_payout"
end
