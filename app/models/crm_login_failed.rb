class CrmLoginFailed < ActiveRecord::Base
  set_table_name 'crm_login_failed'
  attr_accessible :mbr_id, :times, :failed_time1, :failed_time2, :failed_time3, :failed_time4, :failed_time5, :created_by, :modified_by, :modified_on,:rowguid
  hidden_columns :rowguid 
end