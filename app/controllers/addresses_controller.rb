class AddressesController < ApplicationController
  def index
    @addresses = current_user.addresses
    authorize @addresses
    @default_address = current_user.default_address
  end

  def new
    @address = Address.new
    authorize @address
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user

    authorize @address

    if @address.save
      redirect_to addresses_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @address = Address.find(params[:id])
    authorize @address
  end

  def update
    @address = Address.find(params[:id])
    authorize @address

    if @address.update(address_params)
      redirect_to addresses_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address = Address.find(params[:id])
    authorize @address
    @address.destroy

    redirect_to addresses_path, status: :see_other
  end

  def set_default_address # Move to users controller
    current_user.update(default_address_id: params[:address_id])
    redirect_to addresses_path
  end

  private
  def address_params
    params.require(:address).permit(:street, :city, :zip_code, :state, :country)
  end
end
