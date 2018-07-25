module Api::V1
  class ProductsController < ApiController
    before_action :set_product, only: [:show, :update, :destroy]
    before_action :authorize_product_user, only: [:update, :destroy]

    # GET /products
    def index
      @products = Product.page(params[:page] || 1)

      render json: @products, meta: { total_pages: @products.total_pages, page: params[:page] }
    end

    # GET /products/1
    def show
      render json: @product
    end

    # POST /products
    def create
      @product = Product.new(product_params)
      @product.user_id = current_user.id

      if @product.save
        render json: @product, status: :created, location: v1_product_url(@product)
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /products/1
    def update
      if @product.update(product_params)
        render json: @product
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end

    # DELETE /products/1
    def destroy
      @product.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = Product.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def product_params
        params.require(:product).permit(:name, :description, :cost)
      end

      def authorize_product_user
        if @product.user_id != current_user.id
          render json: {error: "You don't have permission to do that."}, status: :forbidden and return
        end
      end
  end
end
