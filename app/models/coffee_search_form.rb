# frozen_string_literal: true

class CoffeeSearchForm
  include ActiveModel::Model

  attr_accessor :query, :selected_coffee, :search_results
end
