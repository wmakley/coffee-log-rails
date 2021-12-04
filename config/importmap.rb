# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/stimulus", to: "stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@hotwired/turbo-rails", to: "turbo.js"
pin "@rails/activestorage", to: "https://cdn.skypack.dev/@rails/activestorage@6.1.4-1"
pin "@rails/requestjs", to: "https://cdn.skypack.dev/@rails/request.js"
