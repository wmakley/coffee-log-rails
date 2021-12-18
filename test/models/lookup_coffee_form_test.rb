# frozen_string_literal: true
require 'test_helper'

class LookupCoffeeFormTest < ActiveSupport::TestCase
  fixtures :coffees

  test "#search_results with empty query returns no results" do
    form = LookupCoffeeForm.new(Coffee.all, query: "")
    search_results = form.search_results.load
    assert search_results.blank?
  end

  test "#search_results with name query finds coffees with that exact name" do
    form = LookupCoffeeForm.new(Coffee.all, query: coffees(:one).name)
    search_results = form.search_results.load
    assert_equal 1, search_results.size
    assert_equal coffees(:one), search_results.first
  end

  test "#search_results with name query finds coffees containing that name" do
    form = LookupCoffeeForm.new(Coffee.all, query: "coffee")
    search_results = form.search_results
    assert_equal Coffee.count, search_results.size
  end

  test "#search_results with selected_coffee_id excludes that coffee" do
    form = LookupCoffeeForm.new(Coffee.all, query: "coffee", coffee_id: "1")
    search_results = form.search_results
    assert_equal Coffee.count - 1, search_results.size
    assert_not search_results.include? coffees(:one)
  end
end
