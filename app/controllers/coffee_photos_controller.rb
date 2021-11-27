# frozen_string_literal: true

class CoffeePhotosController < ApplicationController
  before_action :set_coffee

  def create
    @coffee.params = params.require(:coffee).permit(:photo)
  end

  def destroy
  end

  private

    def set_coffee
      @coffee = Coffee.find(params[:coffee_id])
    end
end
