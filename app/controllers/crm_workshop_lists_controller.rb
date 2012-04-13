class CrmWorkshopListsController < ApplicationController
  before_filter :authenticate
  before_filter :deny_operation, :only=>:show  
  
  def index
    @workshops=CrmWorkshopList.all
  end
  
  def show
    @workshops=CrmWorkshopList.all
    @workshop=CrmWorkshopList.find_by_id(params[:id])
  end
  

  
end
