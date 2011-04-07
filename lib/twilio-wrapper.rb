class TwilioWrapper
  API_VERSION = '2010-04-01'
  attr_reader :account_sid, :account_token, :caller_id, :caller_pin
  
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
    
    send_success = true
    
    unless resp.is_a?(Net::HTTPSuccess)
      send_success = false
      puts resp.body
    end
    
    return send_success
  end
end