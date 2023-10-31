# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base
  # Configure additional authorization contexts here
  # (`user` is added by default).
  #
  #   authorize :account, optional: true
  #
  # Read more about authorization context: https://actionpolicy.evilmartians.io/#/authorization_context

  alias_rule :edit?, to: :update?
  alias_rule :new?, to: :create?

  private

  def allow_admins
    allow! if user.admin?
  end

  # @return [Boolean] true if #record's #user_id property is the same as #user, false otherwise
  def owner?
    record.user_id == user.id
  end

  def allowed_log_ids
    @allowed_log_ids ||= authorized_scope(Log.all).pluck(:id)
  end
end
