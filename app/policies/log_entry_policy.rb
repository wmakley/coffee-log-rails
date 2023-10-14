# frozen_string_literal: true

class LogEntryPolicy < ApplicationPolicy
  relation_scope do |relation|
    next relation if user.admin?

    logs = authorized_scope(Log.all)

    # TODO: use subquery
    log_ids = logs.pluck(:id)

    relation.where(log_id: log_ids)
  end
end
