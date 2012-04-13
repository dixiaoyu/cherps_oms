require 'digest/MD5'
class UserMailer < ActionMailer::Base
  default :from => "cherp@challenger.sg"
  
  def thankyou(user)
    @member = user 
    @password=user.password   
    email=@member.email_addr
    time=@member.created_on.to_s
    string=email+time
    code=Digest::MD5.hexdigest(string)
    @url  = "http://localhost:3000/activeaccount/"+@member.id.to_s+"/"+code
    mail(:to => email, :subject => "Test", :from => "cherp@challenger.sg")
  end 
  
  def resetpw(user)
    @member = user     
    email=@member.email_addr
    #time=@member.created_on.to_s
    @failed=CrmLoginFailed.find_by_mbr_id(@member.mbr_id)
    time=@failed.failed_time5.to_s
    string=email+time
    code=Digest::MD5.hexdigest(string)
    @url  = "http://localhost:3000/resetpw/"+@member.id.to_s+"/"+code
    mail(:to => email, :subject => "ResetPassword", :from => "cherp@challenger.sg")
  end
end
