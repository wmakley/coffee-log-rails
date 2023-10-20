class AddVerificationEmailSentAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :verification_email_sent_at, :timestamp
  end
end
