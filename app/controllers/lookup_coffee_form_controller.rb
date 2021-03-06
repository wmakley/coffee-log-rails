# frozen_string_literal: true

class LookupCoffeeFormController < ApplicationController
  def search_results
    @coffee_search_form = LookupCoffeeForm.new(initial_coffee_scope, coffee_search_form_params)
    @search_results = @coffee_search_form.search_results

    respond_to do |format|
      format.turbo_stream
    end
  end

  def select_coffee
    @coffee_search_form = LookupCoffeeForm.new(initial_coffee_scope, coffee_search_form_params)
    @coffee = @coffee_search_form.selected_coffee

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

    def initial_coffee_scope
      Coffee.includes(:coffee_brand, photo_attachment: :blob)
    end

    def coffee_search_form_params
      params.permit(:query, :coffee_id).to_h
    end
end
