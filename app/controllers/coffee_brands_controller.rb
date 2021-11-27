# frozen_string_literal: true

class CoffeeBrandsController < ApplicationController
  before_action :set_coffee_brand,
                only: [:show, :edit, :update, :destroy]

  def index
    @coffee_brands = CoffeeBrand.by_name_asc
  end

  def show
    @coffees = @coffee_brand.coffees.by_name_asc
  end

  def new
    @coffee_brand = CoffeeBrand.new
  end

  def create
    @coffee_brand = CoffeeBrand.new(coffee_brand_params)
    if @coffee_brand.save
      redirect_to @coffee_brand, notice: "Successfully created coffee brand."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @coffee_brand.update(coffee_brand_params)
      redirect_to @coffee_brand, notice: "Successfully updated coffee brand."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @coffee_brand.destroy
      flash[:notice] = "Successfully deleted coffee brand."
    else
      flash[:error] = "#{@coffee_brand.errors.full_messages.to_sentence}."
    end
    redirect_to coffee_brands_url
  end

  private

    def set_coffee_brand
      @coffee_brand = CoffeeBrand.find(params[:id])
    end

    def coffee_brand_params
      params.require(:coffee_brand).permit(:name, :logo, :url)
    end
end
