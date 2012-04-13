require 'rubygems'
require 'composite_primary_keys'
class CoyAddressBook < ActiveRecord::Base
  set_table_name 'coy_address_book'
  set_primary_keys :coy_id, :ref_type, :ref_id, :addr_type

  attr_accessible :coy_id, :ref_type, :ref_id, :addr_type, :addr_format, :street_line1, :street_line2, :street_line3, :street_line4,
                  :postal_code, :addr_text, :modified_on, :city_name, :state_name, :country_id, :modified_by, :created_by,:modified_on,:rowguid
  hidden_columns :rowguid                 
  def self.get_address(ref_type, ref_id, addr_type)
    where(:coy_id => "CTL", :ref_type => ref_type, :ref_id => ref_id, :addr_type =>addr_type) 
  end

end