import { Controller } from "@hotwired/stimulus"

export default class LogEntryFormController extends Controller {
  static targets = [
    "coffeeTextBox",
    "submitButton"
  ]

  connect() {
    this.enableOrDisableSubmit()
  }

  enableOrDisableSubmit() {
    const val = this.coffeeTextBoxTarget.value.trim()
    this.submitButtonTarget.disabled = (val.length === 0)
  }
}
