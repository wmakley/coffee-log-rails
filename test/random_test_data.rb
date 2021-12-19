# frozen_string_literal: true

module RandomTestData
  ALPHABET = Array('A'..'Z') + Array('a'..'z')

  def random_string(length)
    Array.new(length) { ALPHABET.sample }.join
  end
end
