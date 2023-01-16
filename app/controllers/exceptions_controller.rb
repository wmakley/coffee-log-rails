# frozen_string_literal: true

class ExceptionsController < InternalController
  include AdminRequired

  def index
    raise "wtf"
  end
end
