require 'digest/MD5'
class CrmMemberListsController < ApplicationController
  before_filter :authenticate, :except => [:new, :create, :welcome, :activeaccount, :forgetpw, :checkemail]
  before_filter :deny_operation, :only=>[:show, :detail, :change]
  
  def new
    @member = CrmMemberList.new
    @title = "Signup Page"
  end
  
  def create
    if params[:crm_member_list][:password].length<6
      @title = "Signup Page"
      redirect_to signup_path(:p=>'1') 
    else 
      @member = CrmMemberList.new(params[:crm_member_list])
      @member.coy_id="CTL"
      @member.status_level=0 
      @member.pwd_changed=Time.now   
      @member.last_login=Time.now  
      @member.last_renewal=Time.now  
      @member.mbr_pwd=CrmMemberList.encrypt_password(params[:crm_member_list][:password])
      @member.login_locked="N"
      @member.mbr_addr="0-PRIMARY"
      @member.delv_addr="2-DELIVERY"
      @member.send_info="Y"
      @member.send_type="ByEmail"
      @member.birth_date="1970-01-01"
      @member.join_date=Time.now
      @member.exp_date=2.years.from_now
      @member.last_renewal=Time.now
      @member.created_by=params[:crm_member_list][:first_name]
      @member.modified_by=params[:crm_member_list][:first_name]
      @member.modified_on=Time.now
      @member.points_expired="0.00"
      if @member.save
        #cookies.signed[:remember_token] = {:value=>[@member.coy_id, @member.mbr_id]}
        #sign_in @member
        #sign_in @member
        #flash[:sucess]="Welcome to Challenger!"
        CoyAddressBook.create(:coy_id =>"CTL", :ref_type=>"MEMBER", :ref_id=>@member.mbr_id, :addr_type=>"0-PRIMARY", :addr_format=>"1", :created_by=>params[:crm_member_list][:first_name], :modified_by=>params[:crm_member_list][:first_name], :modified_on=>Time.now)
        CoyAddressBook.create(:coy_id =>"CTL", :ref_type=>"MEMBER", :ref_id=>@member.mbr_id, :addr_type=>"2-DELIVERY", :addr_format=>"1",:created_by=>params[:crm_member_list][:first_name], :modified_by=>params[:crm_member_list][:first_name], :modified_on=>Time.now)
        UserMailer.thankyou(@member).deliver
        redirect_to welcome_path
      else 
        @title = "Signup Page"
        render 'new'
      end
    end  
  end  
  
  def activeaccount
    @member=CrmMemberList.find(params[:id])    
    email=@member.email_addr
    time=@member.created_on.to_s
    string=email+time
    code=Digest::MD5.hexdigest(string)
    if code==params[:code]
      @member.update_attributes(:status_level=>1, :join_date=>Time.now,:last_renewal=>Time.now, :exp_date=>2.years.from_now, :modified_by=>@member.first_name, :modified_on=>Time.now)
      redirect_to signin_path
    else
      redirect_to signup_path  
    end
  end
  
  def show
    @member = CrmMemberList.find(params[:id])   
    if current_user?(@member)
      @title = "Home Page"    
    else
      redirect_to invalid_path  
    end  
  end
  
  def detail
    @member = CrmMemberList.find(params[:id])
    check_expiration(@member)
    
    @address_m=CoyAddressBook.get_address("MEMBER",@member.mbr_id,"0-PRIMARY")
    @address_d=CoyAddressBook.get_address("MEMBER",@member.mbr_id,"2-DELIVERY")
  end
  
  def change
    @member = CrmMemberList.find(params[:id])
    check_expiration(@member)
    
    @address_m=CoyAddressBook.get_address("MEMBER",@member.mbr_id,"0-PRIMARY")
    @address_d=CoyAddressBook.get_address("MEMBER",@member.mbr_id,"2-DELIVERY")
  end
  
  def update
    @member = CrmMemberList.find(params[:id])    
    if params[:crm_member_list][:email_addr].empty? 
      redirect_to change_path(params[:id]), notice: 'Please fill the field with *.'
    else  
      key=params[:mbr_title]
      if key=="1"
        title="MISS"
      elsif key == "2"
        title="MR"
      elsif key=="3"
        title="MRS"
      else
        title="MS"      
      end
      year=params[:birth]['user(1i)']
      month=params[:birth]['user(2i)']
      day=params[:birth]['user(3i)']
      d=Date.new(year.to_i, month.to_i, day.to_i).to_s
      #update member info
      @member.update_attributes(:email_addr => params[:crm_member_list][:email_addr],
                                :mbr_title => title,
                                :birth_date =>d,                                                             
                                :mbr_addr=>"0-PRIMARY",
                                :delv_addr=>"2-DELIVERY",                                 
                                :contact_num => params[:crm_member_list][:contact_num],
                                :modified_by=>@member.first_name,
                                :modified_on=>Time.now)
      
      @address_m=CoyAddressBook.get_address("MEMBER",@member.mbr_id,"0-PRIMARY")    
      fullm_address=params[:m_address1]+" "+params[:m_address2]+" "+params[:m_address3]+" "+params[:m_address4]+" S"+params[:m_postal]
      key_m=params[:m_country]
      if key_m=="1"
        m_country="SG"
      elsif key_m == "2"
        m_country="US"
      elsif key_m=="3"
        m_country="MY"    
      end
      @address_m[0].update_attributes( :addr_format=>"1", :street_line1=>params[:m_address1], :street_line2=>params[:m_address2],
                                    :street_line3=>params[:m_address3], :street_line4=>params[:m_address4], :city_name=>params[:m_city],
                                    :state_name=>params[:m_state], :country_id=>m_country, :postal_code=>params[:m_postal], :addr_text=>fullm_address,
                                    :modified_on=>Time.now,:created_by=>@member.first_name, :modified_by=>@member.first_name)                          
        
      @address_d=CoyAddressBook.get_address("MEMBER",@member.mbr_id,"2-DELIVERY")
      fulld_address=params[:d_address1]+" "+params[:d_address2]+" "+params[:d_address3]+" "+params[:d_address4]+" S"+params[:d_postal]
      key_d=params[:d_country]
      if key_d=="1"
        d_country="SG"
      elsif key_d == "2"
        d_country="US"
      elsif key_d=="3"
        d_country="MY"    
      end
      @address_d[0].update_attributes(:addr_format=>"1", :street_line1=>params[:d_address1], :street_line2=>params[:d_address2],
                                   :street_line3=>params[:d_address3], :street_line4=>params[:d_address4], :city_name=>params[:d_city],
                                   :state_name=>params[:d_state], :country_id=>d_country, :postal_code=>params[:d_postal], :addr_text=>fulld_address, 
                                   :modified_on=>Time.now,:created_by=>@member.first_name, :modified_by=>@member.first_name)                                                    
      
      redirect_to detail_path(params[:id]), notice: 'Profile was successfully updated.'
    end    
  end
  
  def statuscheck    
    @ren_limit = CoySettingList.get_limit("REN_LIMIT")  
    @exp_limit = CoySettingList.get_limit("EXP_LIMIT")  
    @member = CrmMemberList.find(params[:id])
    check_expiration(@member)
  end
  
  def renew
    @member = CrmMemberList.find(params[:id])    
    old_expiry_date = @member.exp_date
    if params[:type]=="1"
      if old_expiry_date < Time.now
        @member.update_attributes(:last_renewal => Time.now, :exp_date => 2.years.from_now, :status_level=>1) 
      else
        new_expiry_date = old_expiry_date+2.years
        @member.update_attributes(:last_renewal => Time.now, :exp_date => new_expiry_date, :status_level=>1)
      end
      max_id=CrmTransactionList.maximum("id") 

      if max_id.nil?
        id=1
      else   
        id = max_id+1
      end
      trans_id="00000"+id.to_s
      #@transaction=CrmMemberTransaction.new(:coy_id=>"CTL", :mbr_id=>current_user.mbr_id,:line_num=>line_num,:trans_date=>Time.now,:item_id=>"8887815245251",:item_desc=>"Challenger Membership Renewal", :item_qty=>1,:trans_points=>"2000")
      @transaction=CrmTransactionList.new(:coy_id=>"CTL", :trans_id=>trans_id, :trans_date=>Time.now,:mbr_id=>current_user.mbr_id,:item_id=>"8887815245251",:item_desc=>"Challenger Membership Renewal", :trans_qty=>1,:trans_points=>"2000", :created_by=>current_user.first_name, :modified_by=>current_user.first_name, :modified_on=>Time.now)
      @transaction.save 
    else
      redirect_to status_path(params[:id]), notice: 'Please choose renewal type.' 
    end         
  end
  
  def welcome
    @title = "Signup Page"
  end
  
  
  
  def invalid
    @title = "Signup Page"
  end
  
  def changepw
    @title = "Home Page"
  end
  
  def updatepw
    if params[:crm_member_list][:current_pw]==session[:password]
      if params[:crm_member_list][:password]==params[:crm_member_list][:password_confirmation]
        if(params[:crm_member_list][:password].length<6)
          #@notice="Your password length is less than 6 characters"  
          redirect_to changepw_path(:n=>"2")
        else  
          mbr_pw=CrmMemberList.encrypt_password(params[:crm_member_list][:password])
          current_user.update_attributes(:mbr_pwd=>mbr_pw, :pwd_changed=>Time.now)        
          reset_session
          session[:password]=params[:crm_member_list][:password]
          redirect_to pwdsuccess_path()
        end  
      else
        #@notice="Your password confirmation doesn't match"  
        redirect_to changepw_path(:n=>"0")
          
      end  
    else
      #@notice="The current password is incorrect"
      redirect_to changepw_path(:n=>"1")  
    end  
    
  end  
  
  def forgetpw
    @title = "Signup Page"
  end  
  
  def checkemail
    email=CrmMemberList.find_by_email_addr(params[:crm_member_list][:email_addr])
    @title = "Signup Page"
    if email.nil?
      flash.now[:error] = "Invalid email address!"        
      render 'forgetpw'
    else      
      UserMailer.resetpw(email).deliver       
    end  
  end  
  
  
    
end

