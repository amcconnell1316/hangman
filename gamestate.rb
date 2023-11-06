require "json"

class HangmanGamestate
  attr_reader :word

  def initialize(word, prev_guesses = [], num_mistakes_left = 15)
    super()
    @word = word
    @prev_guesses = prev_guesses
    @num_mistakes_left = num_mistakes_left
  end

  def to_json
    JSON.dump ({
      :word => @word,
      :prev_guesses => @prev_guesses,
      :num_mistakes_left => @num_mistakes_left
    })
  end

  def self.from_json(string)
    data = JSON.load string
    self.new(data['word'], data['prev_guesses'], data['num_mistakes_left'])
  end

  def display
    display = ''
    @word.each_char do |char|
      if @prev_guesses.include?(char)
        display += char
      else
        display += '_'
      end
      display += " "
    end
    puts display
    puts "Guessed so far: #{@prev_guesses.join}"
    puts "Number of mistakes left: #{@num_mistakes_left}"
  end

  def valid_guess?(guess)
    return guess.match(/[a-z]/) && !@prev_guesses.include?(guess)
  end

  def guess_letter(guess)
    @prev_guesses << guess
    if @word.include?(guess)
      puts "That's a correct guess!"
    else
      puts("#{guess} was not in the word")
      @num_mistakes_left -= 1
    end
  end

  def game_over?
    return true if @num_mistakes_left == 0
    @word.each_char do |char|
      return false unless @prev_guesses.include?(char)
    end
    return true # All characters have been guessed
  end

  def game_won?
    @num_mistakes_left > 0
  end
end