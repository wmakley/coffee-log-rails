# frozen_string_literal: true

module RandomTestData
  ALPHABET = Array("A".."Z") + Array("a".."z")

  def random_string(length)
    Array.new(length) { ALPHABET.sample }.join
  end

  def random_email
    random_string(8) + "@test.com"
  end
end
