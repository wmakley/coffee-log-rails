# frozen_string_literal: true

class InertiaController < ApplicationController
  layout "inertia"

  # Share data with all Inertia responses
  # see https://inertia-rails.dev/guide/shared-data
  #   inertia_share user: -> { Current.user&.as_json(only: [:id, :name, :email]) }
  inertia_share auth: -> { Current.user&.as_json(only: [:id, :display_name, :email]) }
end
