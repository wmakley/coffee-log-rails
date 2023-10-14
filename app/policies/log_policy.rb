# frozen_string_literal: true

class LogPolicy < ApplicationPolicy
  relation_scope do |relation|
    next relation if user.admin?

    user_group_ids = user.user_group_ids
    # if user belongs to no groups, can use simplest query
    if user_group_ids.blank?
      next relation.where(user_id: user.id)
    end

    relation.joins(user: :group_memberships).where(user_id: user.id).or(
      Log.where("group_memberships.user_group_id IN (?)", user_group_ids)
    )
  end
end
