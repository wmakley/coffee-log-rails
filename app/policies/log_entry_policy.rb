# frozen_string_literal: true

class LogEntryPolicy < ApplicationPolicy
  authorize :log

  def index?
    allowed_to?(:show?, log)
  end

  def show?
    allowed_to?(:show?, log)
  end

  def create?
    allowed_to?(:edit?, log)
  end

  def update?
    allowed_to?(:edit?, log)
  end

  def destroy?
    allowed_to?(:edit?, log)
  end

  relation_scope do |relation|
    next relation if user.admin?

    relation.where(log_id: allowed_log_ids)
  end
end
