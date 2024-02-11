class CartsController < ApplicationController
  def show_cart

  end

  def add_product_to_cart
    @cart = Cart.new
    @cart.user = current_user


  end
end
