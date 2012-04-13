class CrmProductList < ActiveRecord::Base
  set_table_name 'crm_product_list'
  has_many :crm_product_reservations
  
  def self.find_through_category(category)
    where(:item_category => category)
  end
  
  def self.find_through_id_category(id,category)
    where(:id=>id,:item_category => category)
  end
end