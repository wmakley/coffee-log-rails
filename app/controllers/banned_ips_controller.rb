# frozen_string_literal: true

class BannedIpsController < ApplicationController
  include AdminRequired

  def index
    @banned_ips = BannedIp.order(created_at: :desc).all
    @login_attempts = LoginAttempt.order(updated_at: :desc).all
  end

  def destroy
    @banned_ip = BannedIp.find(params[:id].to_s.gsub("-", "."))

    if @banned_ip.destroy
      redirect_to banned_ips_url, status: :see_other, notice: "Successfuly un-banned IP address."
    else
      redirect_to banned_ips_url, error: "#{@banned_ip.error.full_messages.to_sentence}."
    end
  end
end
