require 'rubygems'
require 'composite_primary_keys'
class ImsInvPhysical < ActiveRecord::Base
  set_table_name 'ims_inv_physical' 
    
  set_primary_keys :coy_id, :loc_id, :item_id, :line_num

  attr_accessible :qty_on_hand, :qty_reserved,:rowguid, :modified_on
  
  belongs_to :crm_redemption_list, :foreign_key => "item_id"
 
  def self.find_through_item_id(item_id)
    where(:item_id => item_id)
  end
  
  def self.find_through_loc_item(loc_id,item_id,coy_id)
    where(:loc_id => loc_id, :item_id =>item_id, :coy_id =>coy_id )
  end
  
end