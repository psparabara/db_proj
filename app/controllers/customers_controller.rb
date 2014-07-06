class CustomersController < ApplicationController
  include ApplicationHelper
  before_filter :check_signed_in

  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
    @loans = LcRelationship.where(customer_id: params[:id])
    @accounts = AcRelationship.where(customer_id: params[:id])
  end

  def new
    @customer = Customer.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @customer = Customer.create(params[:customer])
    if @customer.save
      flash[:success] = "Customer added successfully"
      redirect_to current_employee
    else
      flash.now[:warning] = "Information invalid!"
      render :new
    end
  end

  def destroy
    customer = Customer.find(params[:id])
    customer.destroy
    redirect_to current_employee
  end
end
