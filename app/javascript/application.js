// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import * as ActiveStorage from "@rails/activestorage";
ActiveStorage.start();

Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.target);
};

import "controllers";
