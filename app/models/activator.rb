class Activator < ActionMailer::Base
  
  def signup_token(activation, host)
    subject    'Activator#deliver_signup_token'
    recipients activation.email
    from       'zaqpki@zaqpki.pl'
    sent_on    Time.now
    
    body       :token => activation.token, :host => host
  end

end
