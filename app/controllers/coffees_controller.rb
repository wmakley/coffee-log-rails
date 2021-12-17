# frozen_string_literal: true

class CoffeesController < ApplicationController
  before_action :set_coffee, only: [:show, :edit, :update, :destroy]

  def index
    @coffees = Coffee.all
                     .with_attached_photo
                     .includes(:coffee_brand, :roast)

    params[:sort] ||= session[:coffee_sort].presence || "most_recent"
    if params[:sort].present?
      @coffees = @coffees.user_sorted(sort_param)
    else
      @coffees = @coffees.by_most_recent
    end
  end

  def sort
    session[:coffee_sort] = sort_param
    @coffees = Coffee.all
                     .with_attached_photo
                     .includes(:coffee_brand, :roast)
                     .user_sorted(sort_param)
  end

  def show
    @log_entries = @coffee.log_entries.by_date_desc.includes(:log)
  end

  def new
    @coffee = Coffee.new(process: "Washed")
    set_coffee_brand_options
  end

  def create
    @coffee = Coffee.new(coffee_params)

    if @coffee.save
      redirect_to @coffee, notice: "Successfully created coffee."
    else
      set_coffee_brand_options
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
    set_coffee_brand_options
  end

  def update
    if @coffee.update(coffee_params)
      redirect_to @coffee, notice: "Successfully updated coffee."
    else
      set_coffee_brand_options
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @coffee.destroy
      flash[:notice] = "Successfully deleted coffee."
    else
      flash[:error] = "There were one or more errors deleting this coffee: #{@coffee.errors.full_messages.to_sentence}."
    end
    redirect_to coffees_url
  end

  private

    def set_coffee
      @coffee = Coffee.find(params[:id])
    end

    def set_coffee_brand_options
      @coffee_brand_options = CoffeeBrand.for_select
    end

    def coffee_params
      params.require(:coffee)
            .permit(
              :coffee_brand_id,
              :name,
              :roast_id,
              :notes,
              :photo,
              :origin,
              :process,
              :decaf,
            )
    end

    def sort_param
      params[:sort].to_s
    end
end
