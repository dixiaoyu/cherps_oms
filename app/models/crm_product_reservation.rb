class CrmProductReservation < ActiveRecord::Base
  set_table_name 'crm_product_reservation'
  
  belongs_to :crm_product_list
  hidden_columns :rowguid 
  def self.find_through_id_status(mbr_id,status)
    where(:mbr_id => mbr_id,:status_level => status)
  end
end