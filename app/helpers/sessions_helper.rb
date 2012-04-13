module SessionsHelper
  def sign_in(user)
    #cookies.permanent.signed[:remember_token] = [user.coy_id, user.mbr_id]
    #cookies.signed[:remember_token] = {:value=>[user.coy_id, user.mbr_id], :expires=>1.minute.from_now}
    #cookies.signed[:remember_token] = [user.coy_id, user.mbr_id]
    self.current_user = user    
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user?(user)
    user == current_user
  end
  
  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def deny_operation
    if Time.now>current_user.exp_date && Time.now<current_user.exp_date+2.months
      current_user.update_attributes(:status_level=>-1, :password=>session[:password])
      redirect_to status_path(:id=>current_user.id)       
    end    
  end
  
  def check_expiration(user)
    if !current_user?(user)
      redirect_to invalid_path 
    end  
  end

  private

    def user_from_remember_token
      CrmMemberList.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

end

