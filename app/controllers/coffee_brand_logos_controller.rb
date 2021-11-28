# frozen_string_literal: true

class CoffeeBrandLogosController < ApplicationController
  before_action :set_coffee_brand

  def show
  end

  def destroy
    @coffee_brand.logo.purge
    @coffee_brand.reload

    respond_to do |format|
      format.html do
        flash[:notice] = "Successfully deleted image."
        redirect_to edit_coffee_brand_url(@coffee_brand)
      end
      format.turbo_stream
    end
  end

  private

    def set_coffee_brand
      @coffee_brand = CoffeeBrand.find(params[:coffee_brand_id])
    end
end
