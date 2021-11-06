# frozen_string_literal: true

module IpBanningConcern
  extend ActiveSupport::Concern

  included do
    before_action :check_if_ip_banned
  end

  def check_if_ip_banned
    if Rails.cache.exist?("banned-ips/#{request.remote_ip}")
      Rails.logger.warn "IP Address '#{request.remote_ip}' is banned"
      render file: Rails.root.join("public/404.html"), status: :not_found
    end
  end
end
