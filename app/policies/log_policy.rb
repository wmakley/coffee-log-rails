# frozen_string_literal: true

class LogPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        return scope.all
      end

      user_group_ids = user.user_group_ids
      # if user belongs to no groups, can use simplest query
      if user_group_ids.blank?
        return scope.where(user_id: user.id)
      end

      scope.joins(user: :group_memberships).where(user_id: user.id).or(
        Log.where("group_memberships.user_group_id IN (?)", user_group_ids)
      )
    end
  end
end
