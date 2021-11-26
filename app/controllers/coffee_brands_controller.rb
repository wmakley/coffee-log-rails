# frozen_string_literal: true

class CoffeeBrandsController < ApplicationController
  def index
    @coffee_brands = CoffeeBrand.by_name_asc.without_default
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end
end
