ActionMailer::Base.delivery_method = :smtp 
ActionMailer::Base.smtp_settings = {
    :address => "Exchange.challenger.sg",
    :port => 25,
   # :domain => "bizpoint-intl.com",
    :user_name => "cherp@challenger.sg",
    :password => "Cherps909",
    #:authentication => :none,
    :enable_starttls_auto => true,
    :openssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
 }
 #ActionMailer::Base.default_url_options[:host] = "challenger.sg"
 ActionMailer::Base.perform_deliveries = true 
ActionMailer::Base.raise_delivery_errors = true 
