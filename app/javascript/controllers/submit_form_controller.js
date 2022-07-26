import {Controller} from "@hotwired/stimulus"

/**
 * Submit a form by clicking a submit button
 */
export default class SubmitFormController extends Controller {
  static values = {formId: String}

  submit() {
    // console.log("submit", this)
    const form = document.getElementById(this.formIdValue)
    if (!form) {
      throw new Error(`form with id ${this.formIdValue} not found`)
    }

    const button = form.querySelector(`input[type="submit"],button[type="submit"]`)
    if (!button) {
      throw new Error(`submit input or button not found in form id '${form.id}'`)
    }
    button.click()
  }
}
