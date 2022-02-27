# frozen_string_literal: true

class Temperature
  include Comparable

  attr_reader :celsius

  def initialize(celsius)
    @celsius = celsius.to_f
  end

  class << self
    def fahrenheit(temp_in_fahrenheit)
      new(fahrenheit_to_celsius(temp_in_fahrenheit))
    end

    def celsius(temp_in_celsius)
      new(temp_in_celsius)
    end

    def fahrenheit_to_celsius(temp_in_fahrenheit)
      (temp_in_fahrenheit - 32) / 1.8
    end

    def celsius_to_fahrenheit(temp_in_celsius)
      (temp_in_celsius * 1.8) + 32
    end
  end

  def <=>(other)
    if other.respond_to?(:celsius)
      celsius <=> other.celsius
    elsif other.respond_to?(:to_f)
      celsius <=> other.to_f
    else
      raise ArgumentError, "other temperature does not respond to #celsius or #to_f"
    end
  end

  def fahrenheit
    self.class.celsius_to_fahrenheit(celsius)
  end

  def to_f
    celsius.to_f
  end

  def to_i
    celsius.to_i
  end

  def to_s
    "#{celsius}C"
  end
end
