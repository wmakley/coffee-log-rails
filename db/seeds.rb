# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless User.exists?
  puts "Creating admin user: william:password"
  User.create!(display_name: "William", username: "william", password: "password", admin: true)
end

unless BrewMethod.exists?
  BrewMethod.create!(
    [
      { name: "French Press" },
      { name: "Pour-Over" },
      { name: "Moka Pot" },
      { name: "Drip" },
      { name: "Cup" },
      { id: 0, name: "Other" },
    ]
  )
end

unless Roast.exists?
  Roast.create!(
    [
      { id: 1, name: "Light" },
      { id: 2, name: "Medium-Light" },
      { id: 3, name: "Medium" },
      { id: 4, name: "Medium-Dark" },
      { id: 5, name: "Dark" }
    ]
  )
end
