class CrmWorkshopList < ActiveRecord::Base
  set_table_name 'crm_workshop_list'
  
  has_many :crm_workshop_reservations
end