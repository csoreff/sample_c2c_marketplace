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
      product = Product.find_by_id(purchase_params[:product_id])
      seller = product.user if product
      @new_purchase_service = NewPurchaseService.new(product: product, user: current_user, seller: seller)

      if !product || product.status != "active"
        render json: {error: 'Product is either not available or does not exist'}, status: :not_found
      elsif product && @new_purchase_service.save
        render json: @new_purchase_service.purchase, status: :created, location: v1_purchase_url(@new_purchase_service.purchase)
      else
        render json: @new_purchase_service.purchase.errors, status: :unprocessable_entity
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
