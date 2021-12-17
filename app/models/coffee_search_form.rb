# frozen_string_literal: true

class CoffeeSearchForm
  include ActiveModel::Model
  include ERB::Util

  attr_accessor :initial_scope, :query, :selected_coffee_id, :search_results

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

    if selected_coffee_id.present?
      scope = scope.where.not(id: selected_coffee_id)
    end

    results = scope.search_by_name(query).with_pg_search_highlight
    results.each do |result|
      result.pg_search_highlight = result.pg_search_highlight.gsub(/<\?([^?]*)\?>/) do
        %(<span class="text-danger">#{html_escape($1)}</span>)
      end.html_safe
    end
    results
  end

  def selected_coffee
    @selected_coffee ||= Coffee.find(selected_coffee_id)
  end
end
