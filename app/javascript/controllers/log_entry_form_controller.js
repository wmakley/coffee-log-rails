import { Controller } from "@hotwired/stimulus"

export default class LogEntryFormController extends Controller {
  static targets = [
    "brewMethodSelect",
    "coffeeIdInput",
    "coffeeGramsInput",
    "waterGramsInput",
    "submitButton",
  ]

  connect() {
    this.enableOrDisableSubmit()
    this.waterChanged = false
  }

  clear() {
    const emptyValue = (input) => {
      input.value = ""
    }

    this.coffeeIdInputTarget.value = ""
    this.element.querySelectorAll("input.form-control").forEach(emptyValue)
    this.element.querySelectorAll("textarea").forEach(emptyValue)
    this.brewMethodSelectTarget.selectedIndex = 0
    document.getElementById("selected-coffee-card").innerHTML = ""
    document.getElementById("coffee-search-results").innerHTML = ""

    this.enableOrDisableSubmit()
  }

  onWaterChange() {
    this.waterChanged = !!this.waterGramsInputTarget.value;
  }

  calculateWater() {
    if ( this.waterChanged ) {
      return
    }

    const input = this.coffeeGramsInputTarget.value
    if (!input) {
      return
    }

    const coffeeGrams = parseFloat(input)
    if (isNaN(coffeeGrams)) {
      return
    }
    if (coffeeGrams <= 0) {
      return
    }

    const ratio = 16.6667
    const waterGrams = Math.round(coffeeGrams * ratio)

    this.waterGramsInputTarget.value = waterGrams.toString(10)
  }

  enableOrDisableSubmit() {
    const val = this.coffeeIdInputTarget.value.trim()
    this.submitButtonTarget.disabled = !val
  }
}
