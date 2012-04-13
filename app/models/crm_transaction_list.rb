class CrmTransactionList < ActiveRecord::Base
  set_table_name 'crm_transaction_list'
  attr_accessible :coy_id, :trans_id, :trans_date,:mbr_id, :item_id, :item_desc, :trans_qty, :pay_mode,
                  :trans_amount, :trans_ref1,:trans_ref2,:trans_ref3, :fin_dim2, :fin_dim3, :status_level,
                  :created_by, :modified_by, :modified_on,:id,:rowguid
  hidden_columns :rowguid 
end