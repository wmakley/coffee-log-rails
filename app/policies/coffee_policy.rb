class CoffeePolicy < ApplicationPolicy
  def show?
    user.present?
  end

  def index?
    user.present?
  end

  def new?
    create?
  end

  def create?
    user.present?
  end

  def edit?
    update?
  end

  def update?
    user.present?
  end

  def destroy?
    user.admin?
  end

  relation_scope do |relation|
    next relation if user.admin?

    # currently no restrictions for non-admin users
    relation
  end
end
