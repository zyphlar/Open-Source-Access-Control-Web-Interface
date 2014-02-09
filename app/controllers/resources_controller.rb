class ResourcesController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!

  def destroy
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to(request.env["HTTP_REFERER"]) }
      format.json  { head :ok }
    end
  end
end
