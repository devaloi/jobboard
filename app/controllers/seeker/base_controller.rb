module Seeker
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_seeker!

    private

    def require_seeker!
      redirect_to root_path, alert: "Access denied." unless current_user.seeker?
    end
  end
end
