require_relative 'gamestate'

def get_guess(gamestate)
  guess = ''
  loop do 
    puts 'Guess a letter: '
    guess = gets.chomp.downcase
    break if gamestate.valid_guess?(guess[0]) || guess == 'save'
  end
  guess
end

def save_game(gamestate)
  Dir.mkdir('saved_games') unless Dir.exist?('saved_games')

  filename = "saved_games/game_last.json"

  File.open(filename, 'w') do |file|
    file.puts gamestate.to_json
  end
end

def open_game
  filename = "saved_games/game_last.json"

  file = File.open(filename, 'r') 
  string = file.read.chomp
  file.close
  HangmanGamestate.from_json(string)
end

puts 'Open last saved game?'
open = gets.chomp.downcase
if open == 'yes' || open == 'y'
  gamestate = open_game
else
  dictionary = File.readlines('google-10000-english-no-swears.txt', chomp: true)
  dictionary = dictionary.select {|word| word.length >=5 && word.length <=12}

  gamestate = HangmanGamestate.new(dictionary.sample)
end
keep_going = true
while !gamestate.game_over? && keep_going do
  gamestate.display
  guess = get_guess(gamestate)
  if guess == 'save'
    save_game(gamestate)
    keep_going = false
  else
    gamestate.guess_letter(guess[0])
  end
end

if keep_going
  if gamestate.game_won?
    puts "You guessed the whole word! #{gamestate.word}"
  else
    puts "You ran out of guesses. The word was #{gamestate.word}"
  end
end


