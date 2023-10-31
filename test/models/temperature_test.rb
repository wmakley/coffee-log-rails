# frozen_string_literal: true

require "test_helper"

class TemperatureTest < ActiveSupport::TestCase
  test "value semantics" do
    a = Temperature.new(25)
    assert_equal 25, a

    b = Temperature.new(10)
    assert_equal 10, b

    assert a > b
    assert b < a
  end

  test "converting celsius to fahrenheit" do
    t = Temperature.new(25)
    assert_equal 25, t.celsius
    assert_equal 77, t.fahrenheit
  end

  test "converting fahrenheit to celsius" do
    t = Temperature.fahrenheit(77)
    assert_equal 25, t.celsius
    assert_equal 77, t.fahrenheit
  end
end
