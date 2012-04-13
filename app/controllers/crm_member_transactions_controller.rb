class CrmMemberTransactionsController < ApplicationController
  before_filter :authenticate  
  def index
    @type=params[:type]
    type=params[:type]
    @load=params[:load]
    if @load.nil?
      if @type =="1"
        @transactions = CrmMemberTransaction.find_through_trans_type(current_user.mbr_id,"RD")
        #@transactions = CrmMemberTransaction.find_by_trans_type("1")
      elsif @type =="2"
        @transactions = CrmMemberTransaction.find_through_trans_type(current_user.mbr_id,"PS")
      #elsif params[:type]=="3"
      elsif @type =="3"
        @transactions = CrmMemberTransaction.find_through_trans_type(current_user.mbr_id,"WS")
      end 
    elsif @load=="1"  
      s_year=params[:start]['date(1i)']
      s_month=params[:start]['date(2i)']
      s_day=params[:start]['date(3i)']
      @from=Date.new(s_year.to_i, s_month.to_i, s_day.to_i).to_s
      
      e_year=params[:till]['date(1i)']
      e_month=params[:till]['date(2i)']
      e_day=params[:till]['date(3i)']
      @to =Date.new(e_year.to_i, e_month.to_i, e_day.to_i).to_s
      
      @transactions = CrmMemberTransaction.filter_through_date(@from,@to,@type)  

    end    
     
  end
  
  def purchaselist
    @load=params[:load]
    if @load.nil?
      @purchases=CrmMemberTransaction.find_purchase(current_user.mbr_id)
    else
      s_year=params[:start]['date(1i)']
      s_month=params[:start]['date(2i)']
      s_day=params[:start]['date(3i)']
      @from=Date.new(s_year.to_i, s_month.to_i, s_day.to_i).to_s
      
      e_year=params[:till]['date(1i)']
      e_month=params[:till]['date(2i)']
      e_day=params[:till]['date(3i)']
      @to =Date.new(e_year.to_i, e_month.to_i, e_day.to_i).to_s
      
      @purchases = CrmMemberTransaction.filter_through_date(@from,@to,"1")  
    end  
  end
end
  

