# frozen_string_literal: true

class LogEntryPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    allow! if user.admin?

    # TODO
    true
  end

  def new?
    create?
  end

  def create?
    true
  end

  def edit?
    update?
  end

  def update?
    allow! if user.admin?

    # TODO
    true
  end

  def destroy?
    allow! if user.admin?

    # TODO
    true
  end

  relation_scope do |relation|
    next relation if user.admin?

    relation.where(log_id: allowed_log_ids)
  end

  private

    def allowed_log_ids
      @allowed_log_ids ||= authorized_scope(Log.all).pluck(:id)
    end
end
