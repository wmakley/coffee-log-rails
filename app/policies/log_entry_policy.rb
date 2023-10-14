class LogEntryPolicy < ApplicationPolicy
  relation_scope do |relation|
    next relation if user.admin?

    # TODO: use subquery
    log_ids = LogPolicy::Scope.new(user, relation).resolve.pluck(:id) # TODO: not correct for action_policy

    relation.where(log_id: log_ids)
  end
end
