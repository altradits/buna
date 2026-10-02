module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :authenticate_admin_user

    private

    def authenticate_admin_user
      # In production, check current_user&.admin?
      # For demonstration / dev testing, allow access or authenticate
      if defined?(current_user) && current_user.present?
        redirect_to root_path, alert: "Access restricted to Yebente Administrators" unless current_user.admin?
      end
    end
  end
end
