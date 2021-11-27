# frozen_string_literal: true

module CoffeeBrandsHelper
  def link_to_coffee_brand_url(coffee_brand)
    if coffee_brand.url.present?
      external_link(coffee_brand.url, coffee_brand.url)
    end
  end
end
