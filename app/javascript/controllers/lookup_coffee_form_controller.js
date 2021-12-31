import {Controller} from "@hotwired/stimulus"
import {get} from "@rails/request.js"
import {debounce} from "debounce"

export default class LookupCoffeeFormController extends Controller {
  static targets = [
    "queryInput",
    "coffeeIdInput",
    "searchResults",
  ]

  static values = {
    endpoint: String,
  }

  connect() {
    if (this.trimmedQuery) {
      this.doSearch(false)
    }
  }

  get trimmedQuery() {
    return this.queryInputTarget.value.trim().replace(/\s+/g, ' ')
  }

  onInput = debounce(() => this.doSearch(), 200)

  /**
   *
   * @param {boolean} updateUrl whether to modify the current location to include the query
   * @returns {Promise<void>}
   */
  async doSearch(updateUrl = true) {
    const query = this.trimmedQuery
    if (!query) {
      return
    }

    // console.log("doSearch", query)
    if (updateUrl) {
      const url = new URL(window.location);
      url.searchParams.set('query', query);
      window.history.pushState({}, '', url);
    }

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

    const coffeeId = row.dataset.resultId
    if (typeof coffeeId !== "string" || coffeeId.length === 0) {
      throw "could not get coffee ID from DOM: " + coffeeId
    }

    const response = await get(this.endpointValue + "/select_coffee", {
      query: {
        coffee_id: coffeeId,
        query: this.trimmedQuery,
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

    const url = new URL(window.location);
    url.searchParams.set('coffee_id', coffeeId);
    window.history.pushState({}, '', url);
  }
}
