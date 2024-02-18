class CartsController < ApplicationController
  def show_cart
    @cart = current_user.cart
    authorize @cart
    @carts_products = @cart.carts_products
    @total_amonut_in_cart = @carts_products.sum { |cp| cp.product.price * cp.product_quantity }
  end

  def add_product_to_cart
    @cart = current_user.cart
    authorize @cart
    @carts_product = CartsProduct.find_by(cart: @cart, product_id: params[:product_id])

    if(@carts_product.nil?)
      # There is no existing record for the same cart and product, we need to create one.
      @carts_product = CartsProduct.new
      @carts_product.cart = current_user.cart
      @carts_product.product_id = params[:product_id]
      @carts_product.product_quantity = 1
    else
      # There is an existing record for the same cart and product, we only need to increase or update the product_quantity.
      unless (params[:product_quantity].nil?)
        @carts_product.product_quantity = params[:product_quantity]
      else
        @carts_product.product_quantity += 1
      end
    end

    if(@carts_product.save)
      redirect_to "/cart"
    else
      redirect_to(request.referrer || products_path)
    end
  end

  def delete_product_from_cart
    @cart = current_user.cart
    authorize @cart
    @carts_product = CartsProduct.find_by(cart: @cart, product_id: params[:product_id])
    @carts_product.destroy

    redirect_to "/cart", status: :see_other
  end
end
