class ResourcesController < ApplicationController
  load_and_authorize_resource
  before_filter :load_users

  def index
    @featured_resource = @resources.where("picture_file_name IS NOT NULL").sample
  end

  def new
    # don't get too excited... for some reason this gets set to the current_user
    @resource.user_id = nil 
  end

  def create
    @resource.modified_by = current_user.id # log who modified this last
    authorize! :create, @resource

    respond_to do |format|
      if @resource.save
        format.html { redirect_to resource_path(@resource), :notice => "Resource was successfully created." }
        format.json { head :no_content }
      else
        format.html { render :action => "new" }
        format.json { render :json => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @resource.modified_by = current_user.id # log who modified this last
    @resource.assign_attributes(params[:resource])
    authorize! :update, @resource

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html { redirect_to resource_path(@resource), :notice => "Resource was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to resources_path, :notice => "Resource was deleted." }
      format.json  { head :ok }
    end
  end

  def load_users
    if can? :assign_user, Resource then
      @users = User.accessible_by(current_ability).sort_by(&:name)
    else
      @users = [current_user]
    end
  end
end
