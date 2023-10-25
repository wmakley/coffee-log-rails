import { Controller } from "@hotwired/stimulus";

export default class LogEntryFormController extends Controller {
  static values = {
    url: String,
  };

  navigate() {
    // console.log("visiting", this.urlValue)
    Turbo.visit(this.urlValue);
  }
}
