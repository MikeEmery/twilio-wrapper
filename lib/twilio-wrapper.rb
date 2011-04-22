require 'twiliolib'

class TwilioWrapper
  API_VERSION = '2010-04-01'
  attr_reader :account_sid, :account_token, :caller_id, :caller_pin, :twilio_response
  
  def initialize(account_sid, account_token, caller_id, caller_pin = nil)
    @account_sid = account_sid
    @account_token = account_token
    @caller_id = caller_id
    @caller_pin = caller_pin
    
    @account = Twilio::RestAccount.new(@account_sid, @account_token)
  end
  
  def sms(recipient_number, message)
    payload = {
      'From' => caller_id,
      'To' => recipient_number,
      'Body' => message
    }
    
    resp = @account.request("/#{API_VERSION}/Accounts/#{@account_sid}/SMS/Messages", 'POST', payload)
    
    send_success = resp.is_a?(Net::HTTPSuccess)
    
    @twilio_response = resp
    
    return send_success
  end
end