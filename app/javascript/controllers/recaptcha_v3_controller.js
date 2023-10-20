import { Controller } from "@hotwired/stimulus"

export default class RecaptchaV3Controller extends Controller {
  static targets = [
    "form",
    "responseField",
    "submit",
  ]

  static values = {
    action: String,
    siteKey: String,
  }

  connect() {
    if (!this.hasFormTarget) {
      throw new Error("No form target found");
    }
    if (!this.hasResponseFieldTarget) {
      throw new Error("No response field target found");
    }
    if (this.hasSubmitTarget) {
      this.submitBtn = this.submitTarget
    } else {
      this.submitBtn = this.element.querySelector('[type="submit"]')
    }
    if (!this.submitBtn) {
      throw new Error("No submit button found")
    }
    if (!this.hasActionValue) {
      throw new Error("No action value found");
    }
    if (!this.hasSiteKeyValue) {
      throw new Error("No site key value found");
    }
  }

  submit(event) {
    if (!event) {
      throw new Error("No event provided");
    }

    // console.debug("submitting");

    if (this.recaptchaResponse) {
      // console.debug("Recaptcha response present:", this.recaptchaResponse, "submitting form")
      return;
    }

    event.preventDefault();
    grecaptcha.enterprise.ready(async () => {
      const token = await grecaptcha.enterprise.execute(
        this.siteKeyValue,
        {
          action: this.actionValue,
        });

      // console.debug("Got Recaptcha token:", token)

      this.responseFieldTarget.value = token;
      this.submitBtn.click();
    });
  }

  get recaptchaResponse() {
    return this.responseFieldTarget.value;
  }
}
