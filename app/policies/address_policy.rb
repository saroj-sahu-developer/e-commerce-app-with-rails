class AddressPolicy < ApplicationPolicy
  def index?
    user.customer? && (record.empty? || record.any? { |address| address.user == user })
  end

  def new?
    user.customer?
  end

  def create?
    user.customer? && user == record.user
  end

  def edit?
    user.customer? && user == record.user
  end

  def update?
    user.customer? && user == record.user
  end

  def destroy?
    user.customer? && user == record.user
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
