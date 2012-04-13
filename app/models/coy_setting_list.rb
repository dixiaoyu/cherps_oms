class CoySettingList < ActiveRecord::Base
  set_table_name 'coy_setting_list'    
  attr_accessible :coy_id, :sys_id, :set_code, :set_data, :created_by, :modified_by,:modified_on,:rowguid                 
  
  def self.get_limit(set_code)
    where(:coy_id => "CTL", :sys_id => "CRM", :set_code =>set_code) 
  end

end