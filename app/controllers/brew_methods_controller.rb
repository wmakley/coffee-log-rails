# frozen_string_literal: true

class BrewMethodsController < InternalController

  before_action :set_brew_method, only: [:show, :edit, :update, :destroy]

  def index
    @brew_methods = BrewMethod.all.by_name
  end

  def show
  end

  def new
    @brew_method = BrewMethod.new
  end

  def create
    @brew_method = BrewMethod.new(brew_method_params)

    if @brew_method.save
      redirect_to brew_methods_url, notice: "Successfully created brew method."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @brew_method.update(brew_method_params)
      redirect_to brew_methods_url, notice: "Successfully updated brew method."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @brew_method.destroy
      redirect_to brew_methods_url, status: :see_other, notice: "Successfully deleted brew method."
    else
      redirect_to brew_methods_url, error: "#{@brew_method.errors.full_messages.to_sentence}."
    end
  end

  private

    def set_brew_method
      @brew_method = BrewMethod.find(params[:id])
    end

    def brew_method_params
      params.require(:brew_method).permit(
        :name,
        :default_brew_ratio,
      )
    end
end
