require 'digest/MD5'
class CrmMemberList < ActiveRecord::Base
  set_table_name 'crm_member_list'
  
  attr_accessor :password, :password_confirmation
  
  attr_accessible :mbr_id, :password, :password_confirmation, :first_name, :last_name, :email_addr, :contact_num,
                  :points_accumulated, :points_reserved, :points_redeemed, :status_level, :mbr_title, :birth_date,
                  :nationality_id, :mbr_addr, :delv_addr, :send_info, :send_type, :last_renewal, :exp_date,
                  :mbr_pwd, :pwd_changed, :join_date, :login_locked,:last_login, :created_by, :modified_by, :modified_on,:rowguid
                    
  has_many :crm_redemption_reservations
  #has_one :coy_address_book
  hidden_columns :rowguid
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #add
  validates :mbr_id,  :presence => true,
                      #:length   => { :within => 6..10 },                       
                      :uniqueness => { :case_sensitive => false }
  #add                     
  validates :email_addr, :presence => true,
                         :uniqueness => true,
                         :format   => { :with => email_regex }
  validates :first_name, :presence => true                                
  validates :last_name,  :presence => true               
  validates :password, :confirmation => true
                      # :length       => { :within => 6..40 } 
  #add
                     
  #before_save :encrypt_password    

  #def has_password?(submitted_password)
  #  self.mbr_pwd == self.encrypt(submitted_password)
  #end  
  
  def self.authenticate(mbr_id, submitted_password)
    member = find_by_mbr_id(mbr_id)    
    #return nil  if member.nil?
    #return member if member.mbr_pwd==encrypt_password(submitted_password)
    if member.nil?
      return nil
    else
      if member.mbr_pwd==encrypt_password(submitted_password) 
        return member
      else
        failed=CrmLoginFailed.find_by_mbr_id(member.mbr_id) 
        if failed.nil?
          failed_times=CrmLoginFailed.create(:mbr_id=>member.mbr_id, :times=>1, :failed_time1=>Time.now, :created_by=>member.first_name, :modified_by=>member.first_name, :modified_on=>Time.now)
          #redirect_To signin_path(:time=>1)
        else 
          if failed.times==0
            failed.update_attributes(:times=>1, :failed_time1=>Time.now,:modified_on=>Time.now) 
          elsif failed.times==1
            failed.update_attributes(:times=>2, :failed_time2=>Time.now,:modified_on=>Time.now) 
            #redirect_To signin_path(:time=>2)
          elsif failed.times==2
            failed.update_attributes(:times=>3, :failed_time3=>Time.now,:modified_on=>Time.now) 
            #redirect_To signin_path(:time=>3)
          elsif failed.times==3
            failed.update_attributes(:times=>4, :failed_time4=>Time.now,:modified_on=>Time.now) 
            #redirect_To signin_path
          elsif failed.times==4
            failed.update_attributes(:times=>5, :failed_time5=>Time.now,:modified_on=>Time.now)  
            #redirect_To signin_path(:time=>5)
          elsif failed.times==5
            failed.update_attributes(:times=>6, :failed_time5=>Time.now,:modified_on=>Time.now)
            UserMailer.resetpw(member).deliver
            member.update_attributes(:login_locked=>"Y",:modified_on=>Time.now)
            #redirect_to failed_path               
          end 
        end
        return nil
      end  
    end
  end 
  
  def self.authenticate_with_salt(coy_id, mbr_id)
    user = find_by_mbr_id(mbr_id)
    (user && user.coy_id == coy_id) ? user : nil
  end 
  
  def self.updatepoints(mbr_id,accumulated,reserved)
    user = find_by_mbr_id(mbr_id)
    user.update_attributes(:points_accumulated => accumulated, :points_reserved => reserved)        
  end 
  
  def self.encrypt_password(password)
    mbr_pwd = encrypt(password)
  end    
     
   
  def self.encrypt(string)
    secure_hash(string)
  end     
  
  def self.secure_hash(string)
    Digest::MD5.hexdigest(string)
  end   
                 
end
