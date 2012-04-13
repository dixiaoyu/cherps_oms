class SessionsController < ApplicationController
  before_filter :authenticate, :only=>:destroy      
  def new
    if !cookies.signed[:remember_token].nil?
      redirect_to current_user  
    end
  end
  
  def create
    user=CrmMemberList.authenticate(params[:session][:mbr_id],params[:session][:password])
    session[:password] = params[:session][:password]
    if user.nil?
      member=CrmMemberList.find_by_mbr_id(params[:session][:mbr_id])
      if !member.nil?
        failed=CrmLoginFailed.find_by_mbr_id(params[:session][:mbr_id])        
        if failed.times<6
          flash.now[:error] = "Invalid email/password combination.You have failed "+failed.times.to_s+" times."          
          @title = "Sign in"
          render 'new'
        else
          member.update_attributes(:mbr_pwd=>"qweasdfghcvbfdgfda")          
          redirect_to failed_path  
        end
      else     
      # Create an error message and re-render the signin form.
        flash.now[:error] = "Invalid email/password combination."
        @title = "Sign in"
        render 'new'
      end
    elsif user.status_level == 0
      flash.now[:error] = "Please active your account."
      @title = "Sign in"
      render 'new'  
    elsif user.status_level == -1
      flash.now[:error] = "Your account has expiried."
      @title = "Sign in"
      render 'new'    
    else
      #if Time.now>user.exp_date && Time.now <=user.exp_date+2.months
        #user can login renew and change rebeat
      #elsif Time.now>=user.exp_date+2.months
      if Time.now>=user.exp_date+2.months  
        user.update_attributes(:status_level=>-1)
        redirect_to signin_path, :notice => "Sorry, your membership has expiried."
      elsif
        if params[:remember]=="1"
          cookies.signed[:remember_token] = {:value=>[user.coy_id, user.mbr_id], :expires=>15.days.from_now}          
        else
          cookies.signed[:remember_token] = {:value=>[user.coy_id, user.mbr_id]}          
        end
        user.update_attributes(:last_login=>Time.now)
        sign_in user    
        redirect_to user  
      end    
    end
  end

  def destroy     
    sign_out
    redirect_to root_path 
  end

end
