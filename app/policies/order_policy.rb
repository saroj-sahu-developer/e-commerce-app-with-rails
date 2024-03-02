class OrderPolicy < ApplicationPolicy
  def create?
    user.customer? && record.address.user == user
  end

  def index?
    user.customer?
  end

  def show?
    if user.customer?
      record.user == user
      # custemers can visit only their orders
    elsif user.admin?
      true
      # admins can visit all orders
    else
      false
    end
  end

  def bulk_edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def bulk_update?
    user.admin?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
