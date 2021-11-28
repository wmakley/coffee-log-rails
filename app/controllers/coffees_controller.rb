# frozen_string_literal: true

class CoffeesController < ApplicationController
  before_action :set_coffee, only: [:show, :edit, :update, :destroy]

  def index
    @coffees = Coffee.all.by_name_asc.includes(:coffee_brand, :photo_attachment)
  end

  def show
    @coffee = Coffee.find(params[:id])

    @log_entries = @coffee.log_entries.by_date_desc.includes(:log)
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

  def destroy
    if @coffee.destroy
      flash[:notice] = "Successfully deleted coffee."
    else
      flash[:error] = "There were one or more errors deleting this coffee: #{@coffee.errors.full_messages.to_sentence}"
    end
    redirect_to coffees_url
  end

  private

    def set_coffee
      @coffeee = Coffee.find(params[:id])
    end

    def coffee_params
      params.require(:coffee)
            .permit(:coffee_brand_id, :name, :roast, :notes, :photo)
    end
end
