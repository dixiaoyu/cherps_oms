class CrmMemberTransaction < ActiveRecord::Base
  set_table_name 'crm_member_transaction'
  attr_accessible :coy_id,:mbr_id,:trans_id,:line_num, :trans_date,:item_id, :item_desc,:item_qty,:trans_points,:rowguid
  default_scope :order => 'crm_member_transaction.trans_date DESC'
  
  
  
  def self.find_through_trans_type(mbr_id,trans_type)
    where(:mbr_id=>mbr_id,:trans_type => trans_type)
  end  
  
  def self.filter_through_date(from,till,type,mbr_id)    
    where("trans_date>=? and trans_date<=? and trans_type=? and mbr_id=? ",from,till,type,mbr_id)
  end
  
  def self.all_transaction(mbr_id)
    where("mbr_id"=>mbr_id)
  end
  
  def self.find_purchase(mbr_id)
    where(:mbr_id=>mbr_id, :trans_type=>"PS")
  end
  
  def self.find_item(mbr_id,trans_id)
    where(:mbr_id=>mbr_id, :trans_type=>"PS", :trans_id=>trans_id)
  end

end
