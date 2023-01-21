# frozen_string_literal: true

module Auth
  class SignupsController < ExternalController
    def show
      redirect_to action: :new
    end

    alias index show

    def new
      @signup = ::Signup.new
    end

    def create
    end
  end
end
