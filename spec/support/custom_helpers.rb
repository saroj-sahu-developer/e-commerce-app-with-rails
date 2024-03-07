module RSpecHelpers
  random_char = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
  RANDOM_CHARACTER = random_char.sample

  def string_having_more_than_255_characters
    random_number = rand(256..1000)
    RANDOM_CHARACTER * random_number
  end

  def string_having_more_than_20_characters
    random_number = rand(21..500)
    RANDOM_CHARACTER * random_number
  end

  def string_having_more_than_1000_characters
    random_number = rand(1001..10000)
    RANDOM_CHARACTER * random_number
  end
end

RSpec.configure do |config|
  config.include RSpecHelpers
end
