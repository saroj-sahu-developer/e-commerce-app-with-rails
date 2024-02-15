class AddressesController < ApplicationController
  def index
    @addresses = current_user.addresses
    authorize @addresses 
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

  private
  def address_params
    params.require(:address).permit(:street, :city, :zip_code, :state, :country)
  end
end
