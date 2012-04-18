#ActionMailer::Base.delivery_method = :smtp 
 
ActionMailer::Base.smtp_settings = {
    
    :address => "exchange.challenger.sg",
    #:address=>"smtp.gmail.com",
    :port => 25,
    :domain => "challenger.sg",
    :user_name => "cherps@challenger.sg",
    :password => "cherps99",
    :authentication => :login
    #:enable_starttls_auto => false

    #:authentication => :ntlm
    
 }
#ActionMailer::Base.default_url_options[:host] = "challenger.com.sg"
 #ActionMailer::Base.perform_deliveries = true 
 #ActionMailer::Base.raise_delivery_errors = true 
