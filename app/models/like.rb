# frozen_string_literal: true

# == Schema Information
#
# Table name: likes
#
#  id            :bigint           not null, primary key
#  likeable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  emoji_id      :bigint           not null
#  likeable_id   :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_likes_on_emoji_id                                   (emoji_id)
#  index_likes_on_likeable_type_and_likeable_id_and_user_id  (likeable_type,likeable_id,user_id) UNIQUE
#  index_likes_on_user_id                                    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (emoji_id => emojis.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :user
  belongs_to :emoji
end
