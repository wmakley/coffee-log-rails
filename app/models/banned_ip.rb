# frozen_string_literal: true

# == Schema Information
#
# Table name: banned_ips
#
#  ip_address :string           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BannedIp < ApplicationRecord
  self.primary_key = :ip_address

  validates :ip_address, presence: true

  def self.ban(ip_address)
    logger.info "Banning IP: #{ip_address}"
    ip = find_or_create_by!(ip_address: ip_address)
    ip.touch
    ip
  end

  def self.banned?(ip_address)
    exists?(ip_address)
  end

  def self.remove_old_bans
    where("updated_at < ?", 1.day.ago).delete_all
  end

  def to_param
    ip_address.gsub(".", "-")
  end
end
