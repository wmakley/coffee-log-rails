import {Controller} from "@hotwired/stimulus"

export default class ClickElementController extends Controller {
  static values = {id: String}

  click() {
    document.getElementById(this.idValue).click()
  }
}
