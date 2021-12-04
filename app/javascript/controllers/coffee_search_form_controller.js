import {Controller} from "@hotwired/stimulus"
import {get} from "@rails/request.js"

export default class CoffeeSearchFormController extends Controller {
  static targets = [
    "queryInput",
    "coffeeIdInput",
  ]

  static values = {
    endpoint: String,
  }

  async doSearch() {
    const query = this.queryInputTarget.value.trim()

    if (!query) {
      return
    }

    let endpoint = this.endpointValue
    if (!endpoint) {
      throw `no endpoint: ${endpoint}`
    }

    const headers = new Headers();
    headers.append('Accept', 'text/vnd.turbo-stream.html');

    const response = await get(endpoint, {
      query: {
        query: query,
      },
      responseKind: 'turbo-stream',
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
    if (!response.ok) {
      throw "fetch failed :("
    }
  }
}
