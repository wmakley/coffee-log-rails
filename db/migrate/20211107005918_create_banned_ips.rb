class CreateBannedIps < ActiveRecord::Migration[6.1]
  def change
    create_table :banned_ips, id: false do |t|
      t.string :ip_address, primary_key: true

      t.timestamps
    end
  end
end
