class CheckoutController < ApplicationController
  def show
    cart = current_user.cart
    authorize(:checkout)

    @all_products_in_cart = cart.carts_products.includes(:product)
    # Joined cart.carts_products with products to avoid database calling inside loop

    if(@all_products_in_cart.empty?)
      return redirect_to "/cart"
    end

    @addresses = current_user.addresses
    @default_address = current_user.default_address
    @total_amount = @all_products_in_cart.sum { |record| record.product.price * record.product_quantity }
    @payment_modes = Payment::VALID_PAYMENT_MODES
  end
end
