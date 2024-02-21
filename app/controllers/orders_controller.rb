class OrdersController < ApplicationController
  def create
    # Request payload has :address_id, :payment_mode, :total_amount

    selected_address = Address.find(params[:address_id])
    # Create record for orders table
    @order = Order.new(
      user: current_user,
      address: selected_address,
      status: "Initialised"
    )
    authorize @order

    # Fetch all the products from cart
    carts_products = current_user.cart.carts_products
    # Join carts_products with products to avoid database calling inside loop
    carts_products_joins_products = carts_products.includes(:product)

    # Create records for orders_products table
    @orders_products = carts_products_joins_products.map do |record|
      {
        order: @order,
        product_id: record.product_id,
        product_quantity: record.product_quantity,
        product_unit_price: record.product.price
      }
    end

    # create record for payments table
    @payment = Payment.new(
      order: @order,
      total_amount: params[:total_amount],
      payment_mode: params[:payment_mode],
      payment_status: 'Pending',
      payment_date_time: DateTime.now
    )

    # start a transaction to complete an order process
    begin
      ActiveRecord::Base.transaction do
        # save record in orders table
        @order.save!

        # save records in orders_products table
        OrdersProduct.create!(@orders_products)

        # save payments table record
        @payment.save!

        # Delete products from cart
        carts_products.destroy_all
      end
      # transaction was completed to place an order

      redirect_to orders_path, status: :ok
    rescue => e
      # When exception occurs in transaction
      puts "Error while saving the records: #{e.message}"
      redirect_to (request.referrer || 'checkout')
    end
  end

  def index
    orders = current_user.orders.order(created_at: :desc)

    # Joins orders with order_products and products to avoid database calling inside loop
    @orders_with_product_details = orders.includes(orders_products: :product)
  end


  def show
    @order = Order.find(params[:id])
    @payment = @order.payment
    orders_products = @order.orders_products
    # Include the each associated product in orders_products to avoid database calling inside loop
    @order_with_product_details = orders_products.includes(:product)
  end

end
