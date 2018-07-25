class NewPurchaseService
  attr_reader :purchase

  def initialize(params)
    @product = params[:product]
    @user = params[:user]
    @seller = params[:seller]
    @purchase = Purchase.new(product_id: @product.try(:id), user_id: @user.id, amount: @product.try(:cost))
  end

  def save
    ActiveRecord::Base.transaction do
      @product.update_attribute(:status, Product.statuses[:sold])
      @user.update_attribute(:points, @user.points - @purchase.amount)
      @seller.update_attribute(:points, @seller.points + @purchase.amount)
      @purchase.save
    end
  end
end