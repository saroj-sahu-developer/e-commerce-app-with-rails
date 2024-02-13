class CartPolicy < ApplicationPolicy
  def show_cart?
    user.customer? && user == record.user
  end

  def add_product_to_cart?
    user.customer? && user == record.user
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
