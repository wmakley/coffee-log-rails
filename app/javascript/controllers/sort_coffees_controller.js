import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class SortCoffeesController extends Controller {
  static targets = [
    "sortValue",
    "submit",
  ]

  submit() {
    this.submitTarget.click()
  }

  async sort(event) {
    if (event) {
      event.preventDefault()
    }

    const response = await get(this.element.action, {
      query: {
        sort: this.sortValueTarget.value,
      },
      responseKind: 'turbo-stream',
    })
    if (!response.ok) {
      throw "get search results failed :("
    }
  }
}
