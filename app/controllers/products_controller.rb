class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  # for devise gem(:index, :show can se called without signing in/authenticating the user)
  before_action :set_categories, only: [:index, :new, :create, :edit, :update, :remove_image]
  # Need to fetch the categories in new method as in new page, all categories are displayed.

  # Need to fetch the categories in create method as if the validation fails, create method will render new page with the same instance of product(For which user had entered some data but that failed to save).And in new page(new.htm.erb), we have used @categories. and now we rendered that page using create method.

  # Need to fetch the categories in edit method as in edit page, all categories are displayed.

  # Need to fetch the categories in update method as if the validation fails, update method will render edit page with the same instance of product(For which user had entered some data but that failed to save).And in edit page(edit.htm.erb), we have used @categories. and now we rendered that page using update method.

  before_action :set_product, only: [:edit, :update, :destroy, :show, :remove_image]


  def index
    @products = Product.all

    # Lists products by category_id value
    unless(params[:category_id].nil? || params[:category_id] == 'all')
      @category = Category.find(params[:category_id])
      @products = @category.products
    end

    # List products by search_with value
    unless(params[:search_with].nil?)
      @products = Product.where("name LIKE ?", "%" + params[:search_with] + "%")
    end
  end

  def show
    @product
  end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    authorize @product

    if @product.save
      redirect_to product_path(@product), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @product
  end

  def update
    authorize @product

    if @product.update(product_params)
      redirect_to product_path(@product), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @product
    @product.destroy

    redirect_to products_path, status: :see_other
  end

  def remove_image
    authorize @product
    image = @product.images.find(params[:image_id])

    if image.purge
      redirect_to edit_product_path(@product), notice: 'Image successfully removed.'
    else
      redirect_to edit_product_path(@product), alert: 'Failed to remove image.'
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :description, :price, :quantity_available, :category_id, images: [])
  end

  def set_categories
    @categories ||= Category.all
  end

  def set_product
    @product ||= Product.find_by(id: params[:id])
  end
end
