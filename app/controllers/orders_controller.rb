class OrdersController < ApplicationController
  def create
    # Request payload has :address_id, :payment_mode, :total_amount

    selected_address = Address.find(params[:address_id])
    # Create record for orders table
    @order = Order.new(
      user: current_user,
      address: selected_address
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
    authorize orders

    # Joins orders with order_products and products to avoid database calling inside loop
    @orders_with_product_details = orders.includes(orders_products: :product)
  end


  def show
    @order = Order.find(params[:id])
    authorize @order

    @payment = @order.payment
    orders_products = @order.orders_products
    # Include the each associated product in orders_products to avoid database calling inside loop
    @order_with_product_details = orders_products.includes(:product)
  end

  def bulk_edit
    # To be used by admin, to handle all customer's orders

    orders = Order.order(created_at: :desc)
    authorize orders
    @orders_with_product_details = orders.includes(:payment, )

    valid_status_options = Order::STATUS_OPTIONS
    # createthe possible status options for each order
    @order_with_possible_status = orders.map do |order|
      select_options_for_order = []
      current_status = order.status
      if current_status.in?(['Delivered', 'Cancelled', 'Failed'])
        select_options_for_order.push(current_status)
      else
        next_option = valid_status_options[valid_status_options.index(current_status) + 1]
        select_options_for_order.push(current_status, next_option, "Failed", "Cancelled")
      end

      {
        order_id: order.id,
        possible_statuses: select_options_for_order
      }
    end
  end

  def update
    order = Order.find(params[:id])
    authorize order
    # To make only the allowed/possible transitions
    # mention aasm(:status) so that aasm can know which state machine to use(here :status) to fetch the permitted transitions, because multiple state machine can present for a model.
    event_called = false
    (order.aasm(:status).permitted_transitions).each do |transition|
      if (transition[:state]).to_s == params[:status]
        order.send(transition[:event])
        event_called = true
        break
      end
    end

    return render :bulk_edit, status: :unprocessable_entity unless event_called
    # if params[:status] doesn't match with any of the possible transaction state(no event called), then exit the function without doing the database call to save the same record without any modification.

    if(order.save)
      redirect_to "/orders/bulk_edit", status: :see_other
    else
      render :bulk_edit, status: :unprocessable_entity
    end
  end

  def bulk_update
    all_orders_to_be_updated = Order.where(id: params[:order_ids])
    authorize all_orders_to_be_updated

    # validates the params['status'] before bulk update because update_all method skips validations
    # unless params[:status].in?(Order::STATUS_OPTIONS)
    #   flash[:alert] = 'Invalid status value.'
    #   return redirect_to(request.referrer || '/orders/bulk_edit')
    # end

    # check all_orders_to_be_updated are allowed to be updated to desired status or not.
    desired_state = params[:status]
    all_orders_to_be_updated.each do |order|
      permitted_states = order.aasm(:status).states(permitted: true).map(&:name)
      unless permitted_states.include?(desired_state.to_sym)
        puts "Order with id #{order.id} can't be updated to status: #{desired_state}"
        flash[:alert] = "Order with id #{order.id} can't be updated to status: #{desired_state}"
        return render :bulk_edit, status: :unprocessable_entity
      end
    end

    all_orders_to_be_updated.update_all(status: desired_state)

    redirect_to "/orders/bulk_edit", status: :see_other
  end

  def get_status_options_for_orders
    orders = Order.where(id: params[:order_ids])

    common_options_for_selected_orders = valid_status_options = Order::STATUS_OPTIONS

    orders.map do |order|
      select_options_for_order = []
      current_status = order.status
      if current_status.in?(['Delivered', 'Cancelled', 'Failed'])
        select_options_for_order.push(current_status)
      else
        next_option = valid_status_options[valid_status_options.index(current_status) + 1]
        select_options_for_order.push(current_status, next_option, "Failed", "Cancelled")
      end
      common_options_for_selected_orders &= select_options_for_order
    end
    render json: {
      multiple_status_options: common_options_for_selected_orders
    }
  end
end
