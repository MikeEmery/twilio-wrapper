require 'twiliolib'

module TwilioWrapper
	
	extend self
	
  API_VERSION = '2010-04-01'
  attr_accessor :account_sid, :account_token, :caller_id, :caller_pin, :twilio_response, :logger
  
  def configure
		yield self
	
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

		if(logger)
			if(send_success)
				logger.debug("Twilio SMS Sent")
			else
				logger.warn("Twilio SMS Failed: #{resp.inspect}")
			end
		end
    
    return send_success
  end
end