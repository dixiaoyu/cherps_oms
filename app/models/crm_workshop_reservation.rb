class CrmWorkshopReservation < ActiveRecord::Base
  set_table_name 'crm_workshop_reservation'
  belongs_to :crm_workshop_list
  hidden_columns :rowguid 
  def self.find_through_mbr_id(mbr_id)
    where(:mbr_id=>mbr_id)
  end
end