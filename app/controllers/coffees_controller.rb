# frozen_string_literal: true

class CoffeesController < ApplicationController
  def index
    @coffees = Coffee.all.by_name_asc.with_photo
  end

  def show
    @coffee = Coffee.find(params[:id])
  end

  def upload_photo
    @coffee = Coffee.find(params[:id])
    @coffee.params = params.require(:coffee).permit(:photo)
  end

  def new
    @coffee = Coffee.new
    @coffee_brand_options = CoffeeBrand.for_select
  end

  def create
    @coffee = Coffee.new(coffee_params)
  end

  def edit
    @coffee = Coffee.find(params[:id])
  end

  def update
    @coffee = Coffee.find(params[:id])
  end

  private

    def coffee_params
      params.require(:coffee)
            .permit(:coffee_brand_id, :name, :roast, :notes, :photo)
    end
end
