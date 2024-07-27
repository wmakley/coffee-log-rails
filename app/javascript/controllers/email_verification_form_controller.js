import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "email", "token", "submit"];

  connect() {
    this.validate();
  }
  validate() {
    const disabled = !this.isValid();
    for (const submit of this.submitTargets) {
      submit.disabled = disabled;
    }
  }

  isValid() {
    return this.emailTarget.value && this.tokenTarget.value;
  }
}
