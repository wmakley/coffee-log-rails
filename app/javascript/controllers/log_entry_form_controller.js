import { Controller } from "@hotwired/stimulus"

export default class LogEntryFormController extends Controller {
  static targets = [
    "brewMethodSelect",
    "coffeeTextBox",
    "submitButton",
  ]

  connect() {
    this.enableOrDisableSubmit()
  }

  clear() {
    this.element.querySelectorAll('input[type="text"]').forEach((input) => {
      input.value = ""
    })
    this.element.querySelector("textarea").value = ""
    this.brewMethodSelectTarget.selectedIndex = 0
  }

  enableOrDisableSubmit() {
    const val = this.coffeeTextBoxTarget.value.trim()
    this.submitButtonTarget.disabled = !val
  }
}
