# frozen_string_literal: true

class InertiaExampleController < InertiaController
  def index
    render inertia: {
      rails_version: Rails.version,
      ruby_version: RUBY_DESCRIPTION,
      rack_version: Rack.release,
      inertia_rails_version: InertiaRails::VERSION,
    }
  end

  def tabs
    render inertia: "inertia_example/tabs/dashboard", props: {}
  end

  def tab_dashboard
    render inertia: "inertia_example/tabs/dashboard", props: {}
  end

  def tab_log_entries
    render inertia: "inertia_example/tabs/log_entries", props: {}
  end

  def tab_my_account
    render inertia: "inertia_example/tabs/my_account", props: {}
  end
end
