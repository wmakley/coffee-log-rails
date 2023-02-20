class LogEntryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # TODO: use subquery
      log_ids = LogPolicy::Scope.new(user, Log).resolve.pluck(:id)

      scope.where(log_id: log_ids)
    end
  end
end
