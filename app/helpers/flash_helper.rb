# frozen_string_literal: true

module FlashHelper
  def flash_alert_class(flash_key)
    case flash_key.to_s
    when "error"
      "is-danger"
    else
      "is-success"
    end
  end

  def flash_icon_tag(flash_key)
    case flash_key.to_s
    when "error"
      %(<svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Danger:"><use xlink:href="#exclamation-triangle-fill"/></svg>).html_safe
    else
      %(<svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Success:"><use xlink:href="#check-circle-fill"/></svg>).html_safe
    end
  end
end
