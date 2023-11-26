# frozen_string_literal: true

# SVG copied from https://icons.getbootstrap.com, bulma sizes guessed
module IconHelper
  def icon_bi_person_fill(size = :normal)
    w, h = *ICON_SIZES.fetch(size)
    raw(<<~SVG)
      <svg xmlns="http://www.w3.org/2000/svg" width="#{w}" height="#{h}" fill="currentColor" class="bi bi-person-fill" viewBox="0 0 16 16">
        <path d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/>
      </svg>
    SVG
  end

  def icon_bi_key_fill(size = :normal)
    w, h = *ICON_SIZES.fetch(size)
    raw(<<~SVG)
      <svg xmlns="http://www.w3.org/2000/svg" width="#{w}" height="#{h}" fill="currentColor" class="bi bi-key-fill" viewBox="0 0 16 16">
        <path d="M3.5 11.5a3.5 3.5 0 1 1 3.163-5H14L15.5 8 14 9.5l-1-1-1 1-1-1-1 1-1-1-1 1H6.663a3.5 3.5 0 0 1-3.163 2zM2.5 9a1 1 0 1 0 0-2 1 1 0 0 0 0 2"/>
      </svg>
    SVG
  end

  ICON_SIZES = {
    normal: [16, 16],
    medium: [25, 25],
  }
end
