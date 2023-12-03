import { Controller } from "@hotwired/stimulus";

export default class RecaptchaV3Controller extends Controller {
  static targets = ["form", "responseField", "submit"];

  static values = {
    action: String,
    siteKey: String,
  };

  connect() {
    if (!this.hasFormTarget) {
      throw new Error("No form target found");
    }
    if (!this.hasResponseFieldTarget) {
      throw new Error("No response field target found");
    }
    if (this.hasSubmitTarget) {
      this.submitBtn = this.submitTarget;
    } else {
      this.submitBtn = this.element.querySelector('[type="submit"]');
    }
    if (!this.submitBtn) {
      throw new Error("No submit button found");
    }
    if (!this.hasActionValue) {
      throw new Error("No action value found");
    }
    if (!this.hasSiteKeyValue) {
      throw new Error("No site key value found");
    }

    this.attempts = 0;
  }

  submit(event) {
    if (!event) {
      throw new Error("No event provided");
    }

    // console.debug("submitting");

    // attempts counter avoids infinite loop if grecaptcha misbehaves
    if (this.recaptchaResponse || this.attempts > 0) {
      // console.debug("Recaptcha response present:", this.recaptchaResponse, "submitting form")
      return;
    }

    event.preventDefault();
    this.attempts += 1;
    grecaptcha.enterprise.ready(async () => {
      const token = await grecaptcha.enterprise.execute(this.siteKeyValue, {
        action: this.actionValue,
      });

      // console.debug("Got Recaptcha token:", token)

      this.responseFieldTarget.value = token;
      // this.element.setAttribute("data-turbo-frame", "_top");
      this.submitBtn.click();
    });
  }

  get recaptchaResponse() {
    return this.responseFieldTarget.value;
  }
}
