# == Schema Information
#
# Table name: coffee_brands
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  notes      :text
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_coffee_brands_on_name  (name) UNIQUE
#
class CoffeeBrand < ApplicationRecord
  include PgSearch::Model

  has_many :coffees, inverse_of: :coffee_brand, dependent: :restrict_with_error

  has_one_attached :logo

  multisearchable against: %i[name notes]

  normalizes :name, with: ->(name) { name.squish }
  normalizes :url, with: ->(url) { url.strip.presence }
  normalizes :notes, with: ->(notes) { notes.strip.gsub(/\r\n?/, "\n").presence }

  validates :name, presence: true, uniqueness: true, length: {maximum: 255}
  validates :url, length: {maximum: 255, allow_nil: true}
  validates :notes, length: {maximum: 4000, allow_nil: true}

  before_destroy do
    if id.zero?
      errors.add(:base, "may not delete default brand")
      throw :abort
    end
  end

  scope :by_name_asc, -> { order(:name) }
  scope :without_default, -> { where.not(id: 0) }

  def self.for_select
    brands = all.by_name_asc.pluck(:name, :id)

    # put brand 0 on top if present
    idx = brands.find_index { |b| b[1].zero? }
    if idx
      re_sorted_brands = [brands[idx]]
      brands.each do |b|
        re_sorted_brands << b if b[1] != 0
      end
      return re_sorted_brands
    end

    brands
  end

  def can_destroy?
    coffees.blank?
  end
end
