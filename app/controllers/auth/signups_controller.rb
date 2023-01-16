# frozen_string_literal: true

module Auth
  class SignupsController < ExternalController
    def show
      redirect_to action: :new
    end

    def new
    end
  end
end
