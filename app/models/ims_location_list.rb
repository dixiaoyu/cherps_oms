class ImsLocationList < ActiveRecord::Base
  set_table_name 'ims_location_list' 
  #attr_accessible :coy_id, :loc_id 
  attr_accessible :coy_id,:rowguid
end