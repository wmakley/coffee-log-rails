# frozen_string_literal: true

class LookupCoffeeForm
  include ActiveModel::Model
  include ERB::Util

  attr_accessor :initial_scope, :query
  attr_reader :coffee_id

  def initialize(initial_scope = Coffee.all, attributes = {})
    @initial_scope = initial_scope
    super(attributes)
  end

  def search_results
    query = self.query.to_s.squish.downcase
    if query.blank?
      return Coffee.none
    end

    scope = initial_scope

    if coffee_id.present?
      scope = scope.where.not(id: coffee_id)
    end

    results = scope.search_by_name(query).with_pg_search_highlight

    replacement_pattern = /<\?([^?]*)\?>/
    results.each do |result|
      result.pg_search_highlight = result.pg_search_highlight.gsub(replacement_pattern) do
        %(<span class="text-danger">#{html_escape($1)}</span>)
      end.html_safe
    end

    results
  end

  def coffee_id=(input)
    if input != coffee_id
      @coffee_id = input
      @selected_coffee = nil
    end
  end

  def selected_coffee
    @selected_coffee ||= Coffee.find(coffee_id)
  end
end
