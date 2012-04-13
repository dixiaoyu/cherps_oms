require "active_record" 
 
class << ActiveRecord::Base  
  def hidden_columns(*hidden)  
    write_inheritable_array("hidden_column", hidden.collect(&:to_s))  
  end 
 
  def columns_hidden 
    read_inheritable_attribute("hidden_column") || []  
  end  
 
  def columns  
    unless defined?(@columns) && @columns  
      @columns = connection.columns(table_name, "#{name} Columns").delete_if {|c| columns_hidden.member?(c.name) }  
      @columns.each {|column| column.primary = column.name == primary_key}  
    end  
    @columns  
  end 
end 
