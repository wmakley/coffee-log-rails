import { Controller } from "@hotwired/stimulus"

export default class LogEntryFormController extends Controller {
  static targets = [
    "coffeeTextBox",
    "submitButton",
    "brewMethodSelect",
    "otherBrewMethod"
  ]

  connect() {
    this.showOrHideOtherBrewMethod()
    this.enableOrDisableSubmit()
  }

  enableOrDisableSubmit() {
    const val = this.coffeeTextBoxTarget.value.trim()
    this.submitButtonTarget.disabled = !val
  }

  showOrHideOtherBrewMethod() {
    const brewMethod = this.brewMethodSelectTarget.value
    if (brewMethod === "Other") {
      this.otherBrewMethodTarget.disabled = false
      this.otherBrewMethodTarget.style.display = ""
      if (this.otherBrewMethodTarget.value === "") {
        this.otherBrewMethodTarget.select()
      }
      // this.otherBrewMethodTarget.value = ""
    } else {
      this.otherBrewMethodTarget.style.display = "none"
      this.otherBrewMethodTarget.disabled = true
    }
  }
}
