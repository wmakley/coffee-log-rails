import { Controller } from "@hotwired/stimulus";

export default class CoffeePhotoUploaderController extends Controller {
  static targets = ["fileField", "submitBtn"];

  fileChanged(event) {
    if (this.fileFieldTarget.value) {
      this.submitBtnTarget.classList.remove("hidden");
    } else {
      this.submitBtnTarget.classList.add("hidden");
    }
  }
}
