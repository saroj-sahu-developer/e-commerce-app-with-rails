class CheckoutController < ApplicationController
  def show
    cart = current_user.cart
    @all_products_in_cart = cart.carts_products.includes(:product)
    @total_amount = @all_products_in_cart.sum { |record| record.product.price * record.product_quantity }
    @addresses = current_user.addresses
    @payment_modes = Payment::VALID_PAYMENT_MODES

    @formatted_orders_request = @all_products_in_cart.map do |carts_product|
      {
        product_id: carts_product.product.id,
        product_quantity: carts_product.product_quantity,
        product_price: carts_product.product.price
      }
    end
  end
end
