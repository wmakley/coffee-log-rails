# == Schema Information
#
# Table name: coffees
#
#  id              :bigint           not null, primary key
#  decaf           :boolean
#  name            :string           not null
#  notes           :text
#  origin          :string
#  process         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  coffee_brand_id :bigint           default(0), not null
#  roast_id        :bigint
#
# Indexes
#
#  index_coffees_on_coffee_brand_id           (coffee_brand_id)
#  index_coffees_on_coffee_brand_id_and_name  (coffee_brand_id,name) UNIQUE
#  index_coffees_on_roast_id                  (roast_id)
#
# Foreign Keys
#
#  fk_rails_...  (coffee_brand_id => coffee_brands.id)
#  fk_rails_...  (roast_id => roasts.id)
#
class Coffee < ApplicationRecord
  include PgSearch::Model

  PROCESSES = %w[Washed Natural Other]

  belongs_to :coffee_brand, inverse_of: :coffees
  belongs_to :roast, inverse_of: :coffees, optional: true

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
  scope :with_brand, -> { includes(:coffee_brand) }
  scope :user_sorted, ->(sort) do
    case sort
    when "name"
      by_name_asc
    when "most_recent"
      order(created_at: :desc)
    when "brand_name"
      with_brand.references(:coffee_brands).order("coffee_brands.name")
    else
      by_name_asc
    end
  end

  validates :name,
            presence: true,
            length: { maximum: 255 },
            uniqueness: { scope: :coffee_brand_id }
  validates :notes,
            length: { maximum: 4000, allow_nil: true }
  validates :origin,
            length: { maximum: 255, allow_nil: true }
  validates :process,
            length: { maximum: 100, allow_nil: true },
            inclusion: { in: PROCESSES, allow_nil: true }

  before_validation do
    self.name = name&.squish
    self.notes = notes&.strip&.gsub(/\r\n?/, "\n").presence
    self.origin = origin&.squish.presence
    self.process = process.presence
  end

  def brand_name
    coffee_brand&.name
  end

  def roast_name
    roast&.name
  end

  alias coffee_brand_name brand_name

  def can_destroy?
    log_entries.blank? && log_entry_versions.blank?
  end
end
