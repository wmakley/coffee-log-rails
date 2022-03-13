class MakeUserEmailCaseInsensitive < ActiveRecord::Migration[7.0]
  def up
    execute "CREATE EXTENSION IF NOT EXISTS citext;"
    execute "ALTER TABLE users ALTER COLUMN email TYPE citext;"
  end

  def down
    execute "ALTER TABLE users ALTER COLUMN email TYPE varchar(255);"
  end
end
