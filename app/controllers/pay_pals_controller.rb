class PayPalsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def process_payment #Create Payment

    recipient_email = params[:recipient_email]
    amount = params[:amount]
    currency = params[:currency]
    description = params[:description]

    access_token = PayPalService.new.get_access_token

    debugger
    payment_response = PayPalService.new.payment_create(recipient_email, amount, currency, description)

    render json: {payment_response: payment_response }
  end

  def payment_return #Approve Payment
    payment_id = params[:paymentId]

    debugger

    if payment_id
      access_token = PayPalService.new.get_access_token
      paypal_service = PayPalService.new
      payment_details = paypal_service.handle_payment_return_url(payment_id)

      if payment_details['error']
        render json: { status: 'error', message: payment_details['error_description'] }, status: :bad_request
      else
        render json: { status: 'success', payment_details: payment_details }, status: :ok
      end
    else
      render json: { status: 'error', message: 'Payment ID is missing' }, status: :unprocessable_entity
    end
  end

  def paypal_payment_execute #Payment compelete
    payment_id = params[:paymentId]
    payer_id = params[:PayerID]

    if payment_id.present? && payer_id.present?
      access_token = PayPalService.new.get_access_token
      paypal_service = PayPalService.new
      result = paypal_service.execute_payment(payment_id, payer_id)

      if result.present? && result['state'] == 'approved'
        render json: { status: 'success', result: result }, status: :ok
      else
        render json: { status: 'error', result: result }, status: :unprocessable_entity
      end
    else
      render json: { status: 'error', message: 'Payment ID or Buyer ID is missing' }, status: :unprocessable_entity
    end
  end

  def cancel
    render json: { status: 'cancelled', message: 'Payment cancelled' }, status: :unprocessable_entity
  end

  def send_payout #Payout
    recipient_email = params[:recipient_email]
    amount = params[:amount]
    currency = params[:currency]
    description = params[:description]

    access_token = PayPalService.new.get_access_token
    payout_response = PayPalService.new.payment_payout(recipient_email, amount, currency, note)

    render json: {payout_response: payout_response }
  end
end
