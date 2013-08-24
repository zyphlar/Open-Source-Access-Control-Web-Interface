class IpnsController < ApplicationController
  load_and_authorize_resource :ipn, :except => "create"
  before_filter :authenticate_user!

  protect_from_forgery :except => [:create]

  def index
    @ipns = Ipn.all
  end

  def show
  end

  def new
  end

  def create
    #TODO: ensure the request is actually from paypal
    @ipn = Ipn.new_from_dynamic_params(params)
    @ipn.data = params.to_json
    @ipn.save
    render :nothing => true
  end

  def link
    result = @ipn.link_payment
    if result.first
      redirect_to ipns_url, :notice => 'Payment was successfully linked.' 
    else
      redirect_to ipns_url, :notice => result.last
    end
  end

end