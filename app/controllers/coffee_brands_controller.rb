# frozen_string_literal: true

class CoffeeBrandsController < InternalController
  before_action :set_coffee_brand,
    only: [:show, :edit, :update, :destroy]

  def index
    authorize!
    @coffee_brands = CoffeeBrand.by_name_asc.with_attached_logo
  end

  def show
    authorize! @coffee_brand
    @coffees = @coffee_brand.coffees.by_name_asc
  end

  def new
    authorize!
    @coffee_brand = CoffeeBrand.new
  end

  def create
    authorize!
    @coffee_brand = CoffeeBrand.new(coffee_brand_params)
    if @coffee_brand.save
      redirect_to @coffee_brand, notice: "Successfully created coffee brand."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! @coffee_brand
  end

  def update
    authorize! @coffee_brand
    if @coffee_brand.update(coffee_brand_params)
      redirect_to @coffee_brand, notice: "Successfully updated coffee brand."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! @coffee_brand
    if @coffee_brand.destroy
      redirect_to coffee_brands_url, status: :see_other, notice: "Successfully deleted coffee brand."
    else
      redirect_to coffee_brands_url, error: "#{@coffee_brand.errors.full_messages.to_sentence.capitalize}."
    end
  end

  private

  def set_coffee_brand
    @coffee_brand = CoffeeBrand.find(params[:id])
  end

  def coffee_brand_params
    params.require(:coffee_brand).permit(:name, :logo, :url, :notes)
  end
end
