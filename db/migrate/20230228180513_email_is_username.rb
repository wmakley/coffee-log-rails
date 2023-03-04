class EmailIsUsername < ActiveRecord::Migration[7.0]
  def up
    users_with_blank_email = User.where(email: nil).pluck(:username, :id)
    if users_with_blank_email.present?
      raise "Users with null email exist, cannot continue. Please fix the following users: #{users_with_blank_email.inspect}"
    end

    # go through active-record to trigger paper-trail callback
    User.find_each do |user|
      user.username = user.email.downcase
      user.save!
    end
  end

  def down
    # do nothing
  end
end
