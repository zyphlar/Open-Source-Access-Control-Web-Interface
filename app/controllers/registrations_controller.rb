class RegistrationsController < Devise::RegistrationsController
  protected

  # After signup
  def after_sign_up_path_for(resource)
    '/users/edit/?flash=welcome_msg'
  end

  # After edit
  def after_update_path_for(resource)
    '/users/edit'
  end

end
