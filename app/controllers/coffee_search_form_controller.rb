# frozen_string_literal: true

class CoffeeSearchFormController < ApplicationController
  def search_results
    @coffee_search_form = CoffeeSearchForm.new(coffee_search_form_params)
    @search_results = @coffee_search_form.search_results.includes(:coffee_brand, :photo_attachment)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def select_coffee
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

    def coffee_search_form_params
      params.permit(:query, :selected_coffee_id).to_h
    end
end
