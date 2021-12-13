import {Controller} from "@hotwired/stimulus"
import {get} from "@rails/request.js"
import {debounce} from "debounce"

export default class CoffeeSearchFormController extends Controller {
  static targets = [
    "queryInput",
    "coffeeIdInput",
    "searchResults",
  ]

  static values = {
    endpoint: String,
  }

  onInput = debounce(() => this.doSearch(), 200)

  async doSearch() {
    const query = this.queryInputTarget.value.trim().replace(/\s+/g, ' ')
    if (!query) {
      return
    }

    // console.log("doSearch", query)

    const response = await get(this.endpointValue + "/search_results", {
      query: {
        query: query,
      },
      responseKind: 'turbo-stream',
    })
    if (!response.ok) {
      throw "get search results failed :("
    }

    this.searchResultsTarget.classList.remove("hidden")
  }

  async selectCoffee(event) {
    event.preventDefault()

    let row = event.target
    if (row.tagName !== 'A') {
      row = event.target.closest('a')
    }

    const coffeeId = row.dataset.coffeeId
    if (typeof coffeeId !== "string" || coffeeId.length === 0) {
      throw "could not get coffee ID from DOM: " + coffeeId
    }

    const response = await get(this.endpointValue + "/select_coffee", {
      query: {
        selected_coffee_id: coffeeId,
      },
      responseKind: 'turbo-stream',
    })
    if (!response.ok) {
      throw "get search results failed :("
    }

    this.coffeeIdInputTarget.value = coffeeId
    this.searchResultsTarget.classList.add("hidden")

    const changeEvent = new Event('change')
    this.coffeeIdInputTarget.closest("form").dispatchEvent(changeEvent)
  }
}
