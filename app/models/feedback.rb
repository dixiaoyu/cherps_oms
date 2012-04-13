class Feedback < ActiveRecord::Base
  set_table_name 'crm_feedback'
  attr_accessible :coy_id, :line_num, :feedback_type, :submit_date,:mbr_id, :visitor_name,
                  :contact_num, :email_addr, :contact_ind, :visit_date, :recript_id, :loc_id, 
                  :feedback_text, :status_level, :action_by, :notes_remarks, :created_by,
                  :modified_by, :modified_on,:rowguid
  hidden_columns :rowguid 
end