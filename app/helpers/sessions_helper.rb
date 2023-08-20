module SessionsHelper
  include Recaptcha::Adapters::ViewMethods

  # Replace implementation from Ruby Gem that just didn't work right
  # with something more obvious that I control/understand.
  def custom_recaptcha_scripts
    site_key = Recaptcha.configuration.site_key!

    buffer = ActiveSupport::SafeBuffer.new
    buffer << javascript_include_tag("https://www.google.com/recaptcha/enterprise.js?render=#{site_key}")
    buffer << javascript_tag(nonce: true) do
      <<~JAVASCRIPT.html_safe
        document.addEventListener("turbo:load", () => {
            const loginForm = document.getElementById("login-form");
            if (loginForm) {
                // console.debug("login form found")

                loginForm.addEventListener('submit', (e) => {
                    // console.debug("submitting");

                    const hiddenField = loginForm.querySelector("input[name='g-recaptcha-response']");
                    if (!hiddenField) {
                        throw new Error("No hidden field for recaptcha response")
                    }
                    const recaptchaResponse = hiddenField.value;
                    if (recaptchaResponse) {
                        // console.debug("Recaptcha response already present:", recaptchaResponse)
                        return;
                    }

                    e.preventDefault();
                    grecaptcha.enterprise.ready(async () => {
                        const token = await grecaptcha.enterprise.execute(
                            "#{escape_javascript(site_key)}", {
                                action: 'login'
                            });

                        // console.debug("Got Recaptcha token:", token)

                        hiddenField.value = token;
                        document.getElementById("submit-btn").click();
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
end
