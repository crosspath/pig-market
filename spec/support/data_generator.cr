module DataGenerator
  ALPHA = ('a'..'z').to_a
  ALPHA_CAPS = ('A'..'Z').to_a
  ALPHA_NUM = ALPHA + (0..9).to_a

  extend self

  def text
    lines = (rand(4) + 1).times.map do # sentences
      words = (rand(12) + 2).times.map do # words
        (rand(20) + 1).times.map { ALPHA.sample }.join # characters
      end
      ALPHA_CAPS.sample + words.join(" ")
    end
    lines.join(". ") + "."
  end

  def name
    ([ALPHA_CAPS.sample] + (rand(18) + 5).times.map { |t| ALPHA.sample }.to_a).join
  end

  def unit_name
    (rand(6) + 1).times.map { |t| ALPHA.sample }.join
  end

  def password
    10.times.map { ALPHA_NUM.sample }.join
  end

  # keep 2 digits after comma/dot (e.g. 1.23)
  def price
    (rand * 10000).ceil / 100
  end

  def count
    rand(5) + 1
  end

  # coin
  def true?
    rand(2) == 1
  end

  # russian roulette
  def shot?
    rand(6) == 0
  end
end
