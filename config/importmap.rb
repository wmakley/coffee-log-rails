# Pin npm packages by running ./bin/importmap

# Application:
pin "application", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# Framework dependencies:
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@hotwired/stimulus", to: "stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.9

# Third-Party dependencies:
pin "stimulus-use" # @0.52.1
