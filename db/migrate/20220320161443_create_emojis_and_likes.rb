class CreateEmojisAndLikes < ActiveRecord::Migration[7.0]
  class Emoji < ActiveRecord::Base
  end

  def up
    create_table :emojis do |t|
      t.string :emoji, limit: 4, null: false
      t.string :name, limit: 100, null: false
      t.integer :order, null: false

      t.timestamps
    end
    add_index :emojis, :order

    create_table :likes do |t|
      t.string :likeable_type, null: false
      t.bigint :likeable_id, null: false
      t.references :user, null: false, foreign_key: true
      t.references :emoji, null: false, foreign_key: true

      t.timestamps
    end
    add_index :likes, [:likeable_type, :likeable_id, :user_id], unique: true

    Emoji.create!([
                    { emoji: "❤️", name: "love", order: 1 },
                    { emoji: "👍", name: "like", order: 5 },
                    { emoji: "✨", name: "sparkle", order: 10 },
                    { emoji: "😊", name: "smile", order: 15 },
                    { emoji: "😂", name: "tears of joy", order: 20 },
                    { emoji: "😢", name: "crying", order: 25 },
                  ])
  end

  def down
    drop_table :likes
    drop_table :emojis
  end
end
