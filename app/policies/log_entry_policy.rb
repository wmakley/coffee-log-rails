# frozen_string_literal: true

class LogEntryPolicy < ApplicationPolicy
  authorize :log

  def index?
    allowed_to?(:show?, log)
  end

  def show?
    allowed_to?(:show?, log)
  end

  def manage?
    allowed_to?(:manage?, log)
  end

  def create?
    allowed_to?(:manage?, log)
  end

  def update?
    allowed_to?(:manage?, log)
  end

  def destroy?
    allowed_to?(:manage?, log)
  end

  relation_scope do |relation|
    next relation if user.admin?

    relation.where(log_id: allowed_log_ids)
  end
end
