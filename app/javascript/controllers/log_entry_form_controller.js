import { Controller } from "@hotwired/stimulus"

export default class LogEntryFormController extends Controller {
  static targets = [
    "brewMethodSelect",
    "coffeeIdInput",
    "coffeeGramsInput",
    "preparationNotes",
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

  onBrewMethodChange() {
    if (this.isNewRecord) {
      this.preparationNotesTarget.value = ""
    }
  }

  get isNewRecord() {
    return this.method === "post"
  }

  get method() {
    if (!this.element._method) {
      return this.element.method.toLowerCase()
    }

    return this.element._method.value.toLowerCase()
  }

  onCoffeeChange() {
    const coffeeGrams = this.parseCoffeeGrams()
    if (coffeeGrams != null) {
      this.coffeeGramsInputTarget.value = Math.round(coffeeGrams)
    }
  }

  onWaterChange() {
    const waterGrams = this.parseWaterGrams()
    if (waterGrams != null) {
      this.waterGramsInputTarget.value = Math.round(waterGrams)
    }

    this.waterChanged = !!this.waterGramsInputTarget.value;
  }

  calculateWater() {
    if (this.waterChanged) {
      return
    }

    const coffeeGrams = this.parseCoffeeGrams()
    if (coffeeGrams === null) {
      return
    }

    const ratio = 16.6667
    const waterGrams = Math.round(coffeeGrams * ratio)

    this.waterGramsInputTarget.value = waterGrams.toString(10)
  }

  /**
   *
   * @returns {number|null}
   */
  parseCoffeeGrams() {
    return this.parseGramsInput(this.coffeeGramsInputTarget.value)
  }

  /**
   *
   * @returns {number|null}
   */
  parseWaterGrams() {
    return this.parseGramsInput(this.waterGramsInputTarget.value)
  }

  /**
   *
   * @param {string} input
   * @returns {null|number}
   */
  parseGramsInput(input) {
    if (!input) {
      return null
    }

    const coffeeGrams = parseFloat(input)
    if (isNaN(coffeeGrams)) {
      return null
    }
    if (coffeeGrams <= 0) {
      return null
    }

    return coffeeGrams
  }

  enableOrDisableSubmit() {
    const coffeeId = this.coffeeIdInputTarget.value.trim()
    const brewMethodId = this.brewMethodSelectTarget.value

    this.submitButtonTarget.disabled = !coffeeId && !brewMethodId
  }
}
