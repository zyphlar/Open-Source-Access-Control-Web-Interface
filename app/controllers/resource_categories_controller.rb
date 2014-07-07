class ResourceCategoriesController < ApplicationController
  load_and_authorize_resource
  layout 'resources'

  def create
    authorize! :create, @resource_category

    respond_to do |format|
      if @resource_category.save
        format.html { redirect_to resource_categories_path, :notice => "Category was successfully created." }
        format.json { head :no_content }
      else
        format.html { render :action => "new" }
        format.json { render :json => @resource_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :update, @resource_category

    respond_to do |format|
      if @resource_category.update_attributes(params[:resource_category])
        format.html { redirect_to resource_categories_path, :notice => "Category was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @resource_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy

    respond_to do |format|
      if @resource_category.destroy
        format.html { redirect_to resource_categories_path, :notice => "Category was deleted." }
        format.json  { head :ok }
      else
        format.html { redirect_to resource_categories_path, :notice => "Category could not be deleted. #{@resource_category.errors.full_messages.first}." }
        format.json { render :json => @resource_category.errors, :status => :unprocessable_entity }
      end
    end
  end

end
