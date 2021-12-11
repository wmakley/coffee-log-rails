module AdminRequired
  extend ActiveSupport::Concern

  included do
    before_action do
      unless current_user.admin?
        flash[:error] = "Not authorized"
        redirect_to root_url
      end
    end
  end
end
