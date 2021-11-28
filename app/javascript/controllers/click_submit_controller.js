import {Controller} from "@hotwired/stimulus"

export default class ClickSubmitController extends Controller {
  static values = {id: String}

  click(event) {
    if (event) {
      event.preventDefault()
    }

    document.getElementById(this.idValue).click()
  }
}
