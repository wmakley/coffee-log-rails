# == Schema Information
#
# Table name: coffees
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  notes           :text
#  roast           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  coffee_brand_id :bigint           default(0), not null
#
# Indexes
#
#  index_coffees_on_coffee_brand_id           (coffee_brand_id)
#  index_coffees_on_coffee_brand_id_and_name  (coffee_brand_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (coffee_brand_id => coffee_brands.id)
#
class Coffee < ApplicationRecord
  include PgSearch::Model

  belongs_to :coffee_brand, inverse_of: :coffees, optional: true
  has_many :log_entries, inverse_of: :coffee, dependent: :restrict_with_error
  has_many :log_entry_versions, inverse_of: :coffee, dependent: :restrict_with_error

  has_one_attached :photo

  pg_search_scope :search_by_name,
                  against: :name,
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }

  scope :by_name_asc, -> { order(:name) }
  scope :with_photo, -> { includes(:photo_attachment) }
  scope :with_brand, -> { includes(:coffee_brand) }

  validates :name,
            presence: true,
            length: { maximum: 255 },
            uniqueness: { scope: :coffee_brand_id }
  validates :roast,
            length: { maximum: 255, allow_nil: true }
  validates :notes,
            length: { maximum: 4000, allow_nil: true }

  before_validation do
    self.name = name&.squish
    self.roast = roast&.squish.presence
    self.notes = notes&.strip&.gsub(/\r\n?/, "\n").presence
  end

  def brand_name
    coffee_brand&.name
  end

  alias coffee_brand_name brand_name

  def can_destroy?
    log_entries.blank? && log_entry_versions.blank?
  end
end
