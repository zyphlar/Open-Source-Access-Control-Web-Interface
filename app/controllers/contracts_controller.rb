class ContractsController < ApplicationController
  load_and_authorize_resource :contract
  before_filter :authenticate_user!, :load_users
  layout 'resources'

  def index
    if params[:user_id].present?
      @contracts = Contract.where(user_id: params[:user_id])
    end
    respond_to do |format|
      format.html 
      format.json { render :json => @contracts }
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
#    if @contract.first_name.blank? && @contract.last_name.blank? && @contract.cosigner.blank? # assume autodetect of filename
#      begin
#        name_split = params[:contract][:document].original_filename.sub(".jpg","").split
#        if name_split.count == 4 # we have one name
#          @contract.first_name = name_split[0]
#          @contract.last_name = name_split[1]
#          # 2 is the hyphen
#          @contract.signed_at = Date.parse(name_split[3])
#        elsif name_split.count == 7 && name_split[2] == "by" # we have two names
#          @contract.first_name = name_split[0]
#          @contract.last_name = name_split[1]
#          # 2 is "by"
#          @contract.cosigner = "#{name_split[3]} #{name_split[4]}"
#          # 5 is the hyphen
#          @contract.signed_at = Date.parse(name_split[6])
#        else
#          Rails.logger.info "Couldn't determine name from filename array: #{name_split.inspect}"
#        end
#      rescue Exception => e
#      end
#    end

    @contract.created_by = current_user
    respond_to do |format|
      if @contract.save
        format.html { redirect_to @contract, :notice => 'Contract was successfully created.' }
        format.json { render :json => @contract, :status => :created, :location => @contract }
      else
        format.html { render :action => "new" }
        format.json { render :json => @contract.errors, :status => :unprocessable_entity }
      end
    end
  end

  def find_for_user
  end

  def update
    respond_to do |format|
      if @contract.update_attributes(params[:contract])
        format.html { redirect_to @contract, :notice => 'Contract was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @contract.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @contract.destroy

    respond_to do |format|
      format.html { redirect_to contracts_url }
      format.json { head :no_content }
    end
  end

  def load_users
    @users = User.accessible_by(current_ability).sort_by(&:name)
  end
end
