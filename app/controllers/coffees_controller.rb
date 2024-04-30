# frozen_string_literal: true

class CoffeesController < InternalController
  before_action :set_coffee, only: [:show, :edit, :update, :destroy]

  def index
    authorize!
    @coffees = authorized_scope(Coffee.all)
      .with_attached_photo
      .includes(:coffee_brand, :roast)

    params[:sort] ||= session[:coffee_sort].presence || "most_recent"
    @coffees = if params[:sort].present?
      @coffees.user_sorted(sort_param)
    else
      @coffees.by_most_recent
    end
  end

  def sort
    authorize! to: :index?
    session[:coffee_sort] = sort_param
    @coffees = Coffee.all
      .with_attached_photo
      .includes(:coffee_brand, :roast)
      .user_sorted(sort_param)
  end

  def show
    authorize! @coffee
    @log_entries = authorized_scope(@coffee.log_entries).by_date_desc.includes(:log)
  end

  def new
    authorize!
    @coffee = Coffee.new(params.permit(:coffee_brand_id))
    @coffee.process ||= "Washed"
    set_coffee_brand_options
  end

  def create
    authorize!
    @coffee = Coffee.new(coffee_params)

    if @coffee.save
      redirect_to @coffee, status: :see_other, notice: "Successfully created coffee."
    else
      set_coffee_brand_options
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! @coffee
    set_coffee_brand_options
  end

  def update
    authorize! @coffee
    if @coffee.update(coffee_params)
      redirect_to @coffee, status: :see_other, notice: "Successfully updated coffee."
    else
      set_coffee_brand_options
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! @coffee
    if @coffee.destroy
      redirect_to coffees_url, status: :see_other, notice: "Successfully deleted coffee."
    else
      redirect_to coffees_url, error: "#{@coffee.errors.full_messages.to_sentence}."
    end
  end

  private

  def set_coffee
    @coffee = authorized_scope(Coffee.all).find(params[:id])
  end

  def set_coffee_brand_options
    @coffee_brand_options = authorized_scope(CoffeeBrand.all).for_select
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
