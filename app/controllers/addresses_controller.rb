class AddressesController < ApplicationController
  def index
    @addresses = current_user.addresses
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user

    if @address.save
      redirect_to addresses_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])

    if @address.update(address_params)
      redirect_to addresses_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    redirect_to addresses_path, status: :see_other
  end

  private
  def address_params
    params.require(:address).permit(:street, :city, :zip_code, :state, :country)
  end
end
