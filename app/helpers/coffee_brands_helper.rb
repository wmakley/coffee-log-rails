# frozen_string_literal: true

module CoffeeBrandsHelper
  def link_to_coffee_brand_url(coffee_brand, html_options = {})
    if coffee_brand.url.present?
      external_link(coffee_brand.url, coffee_brand.url, html_options)
    end
  end

  def coffee_brand_logo_icon(coffee_brand, html_options = {})
    if coffee_brand.logo.attached?
      image_tag(coffee_brand.logo.variant(resize_to_limit: [64, 64]),
                html_options.reverse_merge(alt: "#{coffee_brand.name} Logo"))
    end
  end

  def coffee_brand_logo_large(coffee_brand, html_options = {})
    if coffee_brand.logo.attached?
      image_tag(coffee_brand.logo.variant(resize_to_limit: [200, 200]),
                html_options.reverse_merge(alt: "#{coffee_brand.name} Logo"))
    end
  end

  def coffee_brand_logo_card_top(coffee_brand, html_options = {})
    if coffee_brand.logo.attached?
      image_tag(coffee_brand.logo.variant(resize_and_pad: [400, 300]),
                html_options.reverse_merge(alt: "#{coffee_brand.name} Logo",
                                           class: "card-img-top"))
    end
  end

  def coffee_brand_logo_card_side(coffee_brand, html_options = {})
    if coffee_brand.logo.attached?
      image_tag(coffee_brand.logo.variant(resize_to_fit: [400, 400]),
                html_options.reverse_merge(alt: "#{coffee_brand.name} Logo",
                                           class: "img-fluid rounded-start"))
    end
  end
end
