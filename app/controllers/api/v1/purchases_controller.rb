module Api::V1
  class PurchasesController < ApiController
    before_action :set_purchase, only: [:show]

    # GET /purchases
    def index
      @purchases = Purchase.page(params[:page] || 1)

      render json: @purchases, meta: { total_pages: @purchases.total_pages, page: params[:page] }
    end

    # GET /purchases/1
    def show
      render json: @purchase
    end

    # POST /purchases
    def create
      @purchase = Purchase.new(purchase_params)
      @product = Product.find_by_id(@purchase.product_id)
      @seller = @product.user if @product
      @purchase.amount = @product.cost if @product
      @purchase.user_id = current_user.id

      if @product && @product.status == "active" && @purchase.save
        @product.update_attribute(:status, Product.statuses[:sold])
        current_user.update_attribute(:points, current_user.points - @purchase.amount)
        @seller.update_attribute(:points, @seller.points + @purchase.amount)
        render json: @purchase, status: :created, location: v1_purchase_url(@purchase)
      else
        render json: @purchase.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_purchase
        @purchase = Purchase.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def purchase_params
        params.require(:purchase).permit(:product_id)
      end
  end
end
