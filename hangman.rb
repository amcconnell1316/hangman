require_relative 'gamestate'

def get_guess(gamestate)
  guess = ''
  loop do 
    puts 'Guess a letter: '
    guess = gets.chomp.downcase[0]
    break if gamestate.valid_guess?(guess) 
  end
  guess
end


dictionary = File.readlines('google-10000-english-no-swears.txt', chomp: true)
dictionary = dictionary.select {|word| word.length >=5 && word.length <=12}

gamestate = HangmanGamestate.new(dictionary.sample)

while !gamestate.game_over? do
  gamestate.display
  guess = get_guess(gamestate)
  gamestate.guess_letter(guess)
end

if gamestate.game_won?
  puts "You guessed the whole word! #{gamestate.word}"
else
  puts "You ran out of guesses. The word was #{gamestate.word}"
end


