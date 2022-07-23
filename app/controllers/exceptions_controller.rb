class ExceptionsController < ApplicationController
  include AdminRequired

  def index
    raise "wtf"
  end
end
