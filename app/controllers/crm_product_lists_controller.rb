class CrmProductListsController < ApplicationController
  before_filter :authenticate
  before_filter :deny_operation, :only=>:show  
  
  def index    
    
    if params[:c]=="0"
      @products = CrmProductList.all
    elsif params[:c]=="1"
      @products = CrmProductList.find_through_category("New Arrivals")
    elsif params[:c]=="2"
      @products = CrmProductList.find_through_category("Special Promotion")
    elsif params[:c]=="3"
      @products = CrmProductList.find_through_category("CCCC")   
    elsif params[:c]=="4"
      @products = CrmProductList.find_through_category("DDDD")
    elsif params[:c]=="5"
      @products = CrmProductList.find_through_category("EEEE")   
    elsif params[:c]=="6"
      @products = CrmProductList.find_through_category("FFFF")                  
    end 
  end
  
  def show
    id=params[:id]
    category= params[:c]
    
    if category=="0"
      @products=CrmProductList.all
    else
      if category=="1"  
        cate="New Arrivals"
      elsif category=="2"  
        cate="Special Promotion"
      elsif category=="3"  
        cate="CCCC"
      elsif category=="4"  
        cate="DDDD"  
      elsif category=="5"  
        cate="EEEE" 
      elsif category=="6"  
        cate="FFFF"        
      end    
      @products=CrmProductList.find_through_category(cate) 
    end    
    @product=CrmProductList.find_by_id(id)
  end
  
  def filter
    category=params[:category]
    redirect_to productlist_path(:c=>category)
  end
end
