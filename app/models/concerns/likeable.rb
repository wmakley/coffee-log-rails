# frozen_string_literal: true

module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable, dependent: :delete_all
  end

  def like!(like_params)
    like = Like.new(like_params)
    like.likeable = self
    like.user = Current.user
    like.save!
  end
end
