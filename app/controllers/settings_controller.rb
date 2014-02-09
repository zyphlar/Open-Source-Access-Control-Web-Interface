class SettingsController < ApplicationController
  authorize_resource

  def index
    @settings = Setting.all
    @@default_settings.each do |key, value|
      if @settings[key].blank?
        @settings[key] = value
      end
    end
  end

  def edit
    value = Setting[params[:id].to_sym]
    if value.present?
      @setting = {}
      @setting[:var] = params[:id]
      @setting[:value] = value
    elsif @@default_settings[params[:id].to_sym].present?
      @setting = {}
      @setting[:var] = params[:id]
      @setting[:value] = @@default_settings[params[:id].to_sym]
    end
  end

  def update
    Setting[params[:id]] = params[:value]

    redirect_to settings_path
  end

end
