# frozen_string_literal: true

class CoffeePhotosController < InternalController
  before_action :set_coffee
  before_action :require_photo_attached, only: [:show, :destroy]

  def show
  end

  def create
    respond_to do |format|
      if @coffee.update(params.require(:coffee).permit(:photo))
        @coffee.reload
        format.turbo_stream
      else
        format.turbo_stream
      end
    end
  end

  def destroy
    @coffee.photo.purge
    @coffee.reload

    respond_to do |format|
      format.html do
        redirect_to edit_coffee_url(@coffee), notice: "Successfully deleted photo."
      end
      format.turbo_stream do
        set_coffee_brand_options
      end
    end
  end

  private

    def set_coffee_brand_options
      @coffee_brand_options = CoffeeBrand.for_select
    end

    def set_coffee
      @coffee = Coffee.find(params[:coffee_id])
    end

    def require_photo_attached
      unless @coffee.photo.attached?
        raise ActiveRecord::RecordNotFound.new("Photo not found")
      end
    end
end
