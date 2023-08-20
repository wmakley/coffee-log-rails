module RecaptchaHelpers
  # include Recaptcha::Adapters::ViewMethods

  # Replace implementation from Ruby Gem that just didn't work right
  # with something more obvious that I control/understand.
  def custom_recaptcha_scripts(form_id, action:)
    site_key = if Rails.env.test?
                 Recaptcha.configuration.site_key || "TEST_PLACEHOLDER_KEY"
               else
                 Recaptcha.configuration.site_key!
               end

    buffer = ActiveSupport::SafeBuffer.new
    buffer << javascript_include_tag("https://www.google.com/recaptcha/enterprise.js?render=#{site_key}")
    buffer << javascript_tag(nonce: true) do
      replacements = {
        "{SITE_KEY}" => escape_javascript(site_key),
        "{FORM_ID}" => escape_javascript(form_id),
        "{ACTION}" => escape_javascript(action),
      }

      <<~JAVASCRIPT.gsub(/\{[A-Z_]+}/, replacements).html_safe
        document.addEventListener("turbo:load", () => {
            const form = document.getElementById("{FORM_ID}");
            if (form) {
                let submitBtn = form.querySelector("input[type='submit']");
                if (!submitBtn) {
                    submitBtn = form.querySelector("button[type='submit']");
                }
                if (!submitBtn) {
                    throw new Error("No submit button found")
                }

                const hiddenField = form.querySelector("input[name='g-recaptcha-response']");
                if (!hiddenField) {
                    throw new Error("No hidden field for recaptcha response, use #custom_recaptcha_input_tag")
                }

                form.addEventListener('submit', (e) => {
                    // console.debug("submitting");

                    const recaptchaResponse = hiddenField.value;
                    if (recaptchaResponse) {
                        // console.debug("Recaptcha response already present:", recaptchaResponse)
                        return;
                    }

                    e.preventDefault();
                    grecaptcha.enterprise.ready(async () => {
                        const token = await grecaptcha.enterprise.execute(
                            "{SITE_KEY}", {
                                action: '{ACTION}'
                            });

                        // console.debug("Got Recaptcha token:", token)

                        hiddenField.value = token;
                        submitBtn.click();
                    })
                });
            } else {
                // console.debug("No login form found")
            }
        });
      JAVASCRIPT
    end
    buffer
  end

  def custom_recaptcha_input_tag
    hidden_field_tag "g-recaptcha-response", nil
  end
end
