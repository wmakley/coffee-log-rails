# frozen_string_literal: true

class CoffeeSearchForm
  include ActiveModel::Model

  attr_accessor :query, :selected_coffee_id, :search_results

  def search_results
    query = self.query.to_s.squish.downcase
    if query.blank?
      return Coffee.none
    end

    results = Coffee.search_by_name(query)

    if selected_coffee_id.present?
      results = results.where.not(id: selected_coffee_id)
    end

    results
  end

  def selected_coffee
    @selected_coffee ||= Coffee.find(selected_coffee_id)
  end
end
