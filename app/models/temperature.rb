# frozen_string_literal: true
# typed: true

class Temperature
  extend T::Sig
  include Comparable

  sig { returns(Float) }
  attr_reader :celsius

  sig { params(celsius: T.any(String, Numeric)).void }
  def initialize(celsius)
    @celsius = celsius.to_f
  end

  class << self
    extend T::Sig

    sig { params(temp_in_fahrenheit: T.any(String, Numeric)).returns(Temperature) }
    def fahrenheit(temp_in_fahrenheit)
      new(fahrenheit_to_celsius(temp_in_fahrenheit))
    end

    sig { params(temp_in_celsius: T.any(String, Numeric)).returns(Temperature) }
    def celsius(temp_in_celsius)
      new(temp_in_celsius)
    end

    sig { params(temp_in_fahrenheit: T.any(String, Numeric)).returns(Float) }
    def fahrenheit_to_celsius(temp_in_fahrenheit)
      (temp_in_fahrenheit.to_f - 32) / 1.8
    end

    sig { params(temp_in_celsius: T.any(String, Numeric)).returns(Float) }
    def celsius_to_fahrenheit(temp_in_celsius)
      (temp_in_celsius.to_f * 1.8) + 32
    end
  end

  sig { params(other: T.untyped).returns(Integer) }
  def <=>(other)
    if other.respond_to?(:celsius)
      celsius <=> other.celsius
    elsif other.respond_to?(:to_f)
      celsius <=> other.to_f
    else
      raise ArgumentError, "other temperature does not respond to #celsius or #to_f"
    end
  end

  sig { returns(Float) }
  def fahrenheit
    self.class.celsius_to_fahrenheit(celsius)
  end

  sig { returns(Float) }
  def to_f
    celsius.to_f
  end

  sig { returns(Integer) }
  def to_i
    celsius.to_i
  end

  sig { returns(String) }
  def to_s
    "#{celsius}C"
  end
end
