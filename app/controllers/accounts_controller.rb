class AccountsController < ApplicationController
  include ApplicationHelper
  before_filter :check_signed_in

  def index
    @accounts = Account.all
  end

  def show
    @account = Account.find(params[:id])
    @customers = AcRelationship.where(account_id: params[:id])
  end

  def new
    @account = Account.new
    respond_to do |format|
      format.html
    end
  end

  def create
    if customer = Customer.find_by(ssn: params[:account][:customer_id]) 
      account = Account.create(ac_type: params[:account][:ac_type],
                               balance: params[:account][:balance],
                               branch_id: params[:account][:branch_id])
      if account.save
        flash[:success] = "Account added successfully!"
        AcRelationship.create(account_id: account.acct_no, 
                              customer_id: params[:account][:customer_id]).save
        redirect_to accounts_path
      else
        flash[:danger] = 'Failed!'
        redirect_to accounts_path
      end
    else
      flash[:danger] = "Customer ID invalid!"
      redirect_to accounts_path
    end
  end

  def destroy
    account = Account.find(params[:id])
    account.destroy
    redirect_to accounts_path
  end
end
