class LogPolicy < ApplicationPolicy
  relation_scope do |relation|
    next relation if user.admin?

    relation.visible_to_user(user)
  end
end
