class CrmLoginFailedsController < ApplicationController
  def loginfailed
    @title = "Signup Page"
  end
  
  def resetpw
    @title = "Signup Page"
    @member=CrmMemberList.find_by_id(params[:id])    
    email=@member.email_addr
    @failed=CrmLoginFailed.find_by_mbr_id(@member.mbr_id)
    time=@failed.failed_time5.to_s
    string=email+time
    code=Digest::MD5.hexdigest(string)
    if code!=params[:code]      
      redirect_to failed_path
    end
  end
  
  def renewpw
    @title = "Signup Page"
    
    if params[:crm_login_failed][:password]==params[:crm_login_failed][:password_confirmation]
      mbr_pw=CrmMemberList.encrypt_password(params[:crm_login_failed][:password])
      user= CrmMemberList.find_by_mbr_id(params[:mbr_id])
      user.update_attributes(:mbr_pwd=>mbr_pw, :pwd_changed=>Time.now, :status_level=>1, :login_locked=>"N")  
      failed=CrmLoginFailed.find_by_mbr_id(params[:mbr_id])   
      failed.update_attributes(:times=>0, :failed_time1=>"1900-01-01", :failed_time2=>"1900-01-01", :failed_time3=>"1900-01-01", :failed_time4=>"1900-01-01", :failed_time5=>"1900-01-01")
      redirect_to pwsuccess_path()
    else
      redirect_to changepw_path, :notice=>"Your password confirmation doesn't match"    
    end  
  end 
  
    
  def renewsuccess
     @title = "Signup Page"
  end 
end
