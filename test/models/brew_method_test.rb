# frozen_string_literal: true

require 'test_helper'

class BrewMethodTest < ActiveSupport::TestCase
  fixtures :brew_methods

  def valid_attributes
    {
      name: random_string(8),
      default_brew_ratio: 1,
    }
  end

  test "it saves with valid attributes" do
    brew_method = BrewMethod.new(valid_attributes)
    assert brew_method.save!
  end

  test "may not delete other brew method" do
    brew_method = brew_methods(:other)
    assert_not brew_method.destroy
    assert BrewMethod.exists?(brew_method.id)
  end

  test "for select sorts 'other' to end" do
    opts = BrewMethod.for_select
    assert_equal "Other", opts.last[0]
  end
end
