# Pin npm packages by running ./bin/importmap

# Application:
pin "application", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# Framework dependencies:
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@rails/request.js", to: "https://ga.jspm.io/npm:@rails/request.js@0.0.9/src/index.js"

# Third-Party dependencies:
pin "debounce", to: "https://ga.jspm.io/npm:debounce@1.2.1/index.js"
