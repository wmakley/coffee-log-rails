class AdminEditablePolicy < ApplicationPolicy
  def show?
    true
  end

  def index?
    true
  end

  def new?
    create?
  end

  def create?
    user.admin?
  end

  def edit?
    update?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  relation_scope do |relation|
    relation
  end
end
