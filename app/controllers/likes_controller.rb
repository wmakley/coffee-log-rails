# frozen_string_literal: true

class LikesController
  before_action :set_likeable

  def index
    @likes = @likeable.likes.order(id: :desc)
  end

  def create
    @like = Like.new(likeable: @likeable)
  end

  def destroy
    @like = @likeable.likes.find(params[:id])
    @like.destroy
  end

  private

    def set_likeable
      model_class = params[:likeable_type].constantize
      id = params[params[:likeable_type].underscore + "_id"]
      @likeable = model_class.find(id)
    end
end
