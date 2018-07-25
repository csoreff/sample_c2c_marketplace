class PurchaseCreateService
  def initialize(params)
    @card = params[:card]
    @amount = params[:amount]
    @email = params[:email]
  end

  def save
    begin
      @purchase = Purchase.new(purchase_params)
      @product = Product.find_by_id(@purchase.product_id)
      @seller = @product.user if @product
      @purchase.amount = @product.cost if @product
      @purchase.user_id = current_user.id

      if @product && @product.status == "active" && @purchase.save
        @product.update_attribute(:status, Product.statuses[:sold])
        @seller.update_attribute(:points, @seller.points - @purchase.amount)
      else
        false
      end
    rescue
      false
    end
  end

  private

  attr_reader :card, :amount, :email
end