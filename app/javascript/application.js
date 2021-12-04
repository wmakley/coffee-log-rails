// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import { Turbo } from "@hotwired/turbo-rails"
if (!window.Turbo) {
  console.log("setting window.Turbo")
  window.Turbo = Turbo
}

import railsActivestorage from "@rails/activestorage"
railsActivestorage.start()
