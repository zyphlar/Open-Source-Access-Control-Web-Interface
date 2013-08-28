class PaypalCsvsController < ApplicationController
  load_and_authorize_resource :paypal_csv
  before_filter :authenticate_user!

  def index
  end

  def show
  end

  def new
  end

  def create
    PaypalCsv.batch_import_from_csv(params[:file].path)
    redirect_to paypal_csvs_path, :notice => 'Paypal CSV batch was successfully loaded.' 
  end

  def link
    result = @paypal_csv.link_payment
    if result.first
      redirect_to paypal_csvs_url, :notice => 'Payment was successfully linked.' 
    else
      redirect_to paypal_csvs_url, :notice => result.last
    end
  end

end
