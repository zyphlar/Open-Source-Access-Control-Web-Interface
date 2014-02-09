class ResourcesController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!
end
