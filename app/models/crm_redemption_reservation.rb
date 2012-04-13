class CrmRedemptionReservation < ActiveRecord::Base
  set_table_name 'crm_redemption_reservation'
  belongs_to :crm_redemption_list
  belongs_to :crm_member_list
  hidden_columns :rowguid 
  def self.find_through_id_status(mbr_id,status)
    where(:mbr_id => mbr_id,:status_level => status)
  end
  
end