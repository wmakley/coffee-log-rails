# typed: true

# == Schema Information
#
# Table name: logs
#
#  id         :bigint           not null, primary key
#  slug       :string           not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_logs_on_slug     (slug) UNIQUE
#  index_logs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Log < ApplicationRecord
  has_many :log_entries, inverse_of: :log, dependent: :destroy
  belongs_to :user, inverse_of: :log

  validates :title,
    presence: true,
    length: {maximum: 255}

  validates :slug,
    presence: true,
    uniqueness: true,
    length: {maximum: 255},
    format: /\A[a-z0-9\-_]+\z/

  normalizes :title, with: ->(title) { title.squish }
  normalizes :slug, with: ->(slug) { slug.strip }

  def self.owner(user)
    where(user_id: user.id)
  end

  def self.visible_to_user(user)
    if user.admin?
      return all
    end

    user_group_ids = user.user_group_ids
    # if user belongs to no groups, can use simplest query
    if user_group_ids.blank?
      return where(user_id: user.id)
    end

    scope = joins(user: :group_memberships)
    scope.where(user_id: user.id).or(
      where("group_memberships.user_group_id IN (?)", user_group_ids),
    )
  end

  def self.touch_by_log_entry_scope(log_entry_scope, updated_at = Time.current)
    log_entry_scope = log_entry_scope.select(Arel.sql("distinct log_id"))
    where("id in (#{log_entry_scope.to_sql})").update_all(updated_at: updated_at)
  end

  def to_param
    slug
  end
end
