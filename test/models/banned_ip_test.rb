# frozen_string_literal: true

# == Schema Information
#
# Table name: banned_ips
#
#  ip_address :string           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class BannedIpTest < ActiveSupport::TestCase
  test "it saves with valid attributes" do
    banned_ip = BannedIp.new(ip_address: "1.2.3.4")
    assert banned_ip.save
  end

  test "#ban" do
    assert_not BannedIp.banned?("1.2.3.4")
    ban = BannedIp.ban("1.2.3.4")
    assert ban.persisted?
    assert_equal "1.2.3.4", ban.ip_address
    assert BannedIp.banned?("1.2.3.4")
  end

  test "#remove_old_bans" do
    ban = BannedIp.ban("1.2.3.4")
    ban.update!(updated_at: 2.days.ago)
    assert BannedIp.banned?("1.2.3.4")

    BannedIp.remove_old_bans
    assert_not BannedIp.banned?("1.2.3.4")
  end
end
