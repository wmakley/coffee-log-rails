class CoffeeBrandPolicy < ApplicationPolicy
  def show?
    true
  end

  def index?
    true
  end

  def sort?
    index?
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
    relation
  end
end
