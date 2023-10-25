# Pin npm packages by running ./bin/importmap

# Application:
pin "application", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# Framework dependencies:
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@hotwired/stimulus", to: "stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@rails/request.js", to: "https://ga.jspm.io/npm:@rails/request.js@0.0.9/src/index.js"

# Third-Party dependencies:
pin "stimulus-use", to: "https://ga.jspm.io/npm:stimulus-use@0.52.1/dist/index.js"
