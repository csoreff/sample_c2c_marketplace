module Api::V1
  class UsersController < ApiController

    # GET /v1/users
    def index
      @users = User.page(params[:page] || 1)

      render json: @users, meta: { total_pages: @users.total_pages, page: params[:page] }
    end

    # GET /v1/users/{id}
    def show
      render json: User.find(params[:id])
    end

  end
end
