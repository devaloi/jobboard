module Admin
  class UsersController < BaseController
    def index
      @pagy, @users = pagy(User.order(created_at: :desc), limit: 20)
    end

    def show
      @user = User.find(params[:id])
    end
  end
end
