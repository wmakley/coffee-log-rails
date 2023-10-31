class LogPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    allow! if user.admin?

    owner? || in_my_user_groups?
  end

  def update?
    allow! if user.admin?
    owner?
  end

  def create?
    false
  end

  def destroy?
    false
  end

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

  private

  def in_my_user_groups?
    authorized_scope(Log.all).where(id: log.id).exists?
  end
end
