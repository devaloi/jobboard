class ApplicationController < ActionController::Base
  include Pagy::Backend

  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name company_name role bio])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name company_name bio])
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    elsif resource.employer?
      employer_dashboard_path
    else
      seeker_dashboard_path
    end
  end
end
