import {Controller} from "@hotwired/stimulus"
import {get, patch} from "@rails/request.js"
import {debounce} from "debounce"

export default class CoffeeSearchFormController extends Controller {
  static targets = [
    "queryInput",
    "coffeeIdInput",
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
  }

  async selectCoffee(event) {
    event.preventDefault()

    const coffeeId = event.target.dataset.coffeeId
    if (typeof coffeeId !== "string" || coffeeId.length === 0) {
      throw "could not get coffee ID"
    }

    const response = await patch(this.endpointValue + "/select_coffee", {
      query: {
        coffee_id: coffeeId,
      },
      responseKind: 'turbo-stream',
    })
    if (!response.ok) {
      throw "get search results failed :("
    }
  }

  get searchResultsDiv() {
    return document.getElementById("coffee-search-results")
  }
}
