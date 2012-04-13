
class CrmRedemptionList < ActiveRecord::Base
  set_table_name 'crm_redemption_list' 

  has_many :crm_redemption_lists
  
  has_many :crm_redemption_reservations
  
  def self.find_through_points(p1,p2)    
    where("points_required>=? and points_required<=?",p1,p2)
  end


end