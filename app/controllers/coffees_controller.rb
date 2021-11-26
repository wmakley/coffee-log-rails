# frozen_string_literal: true

class CoffeesController < ApplicationController
  def index
    @coffees = Coffee.all.by_name_asc.with_photo
  end

  def show
    @coffee = Coffee.find(params[:id])
  end

  def new
    @coffee = Coffee.new
  end

  def create
    @coffee = Coffee.new(coffee_params)
  end

  def edit
  end

  def update
  end

  private

    def coffee_params
      params.require(:coffee)
            .permit(:name, :roast, :notes, :photo)
    end
end
