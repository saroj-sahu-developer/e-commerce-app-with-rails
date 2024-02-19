class OrdersController < ApplicationController
  def create
    @order = Order.new
    @order.user = current_user
    @order.address_id = params[:address_id]
    @order.status = "Initialised"

    unless(@order.save)
      return redirect_to (request.referrer || 'checkout')
    end

    orders_request = JSON.parse(params[:orders_request])

    begin
      @orders_products =  orders_request.map do |record|
        {
          order_id: @order.id,
          product_id: record['product_id'],
          product_quantity: record['product_quantity'],
          product_unit_price: record['product_price']
        }
      end

      OrdersProduct.create!(@orders_products)
    rescue => e
      # puts "Error saving records: #{e.message}"
      return redirect_to (request.referrer || 'checkout')
    end

    # Delete products cart
    carts_products = current_user.cart.carts_products
    carts_products.destroy_all

    redirect_to order_path(@order)

  end

  def show; end

end
