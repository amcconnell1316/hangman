
def display_guesses(word, guessed_letters, num_mistakes_left)
  display = ''
  word.each_char do |char|
    if guessed_letters.include?(char)
      display += char
    else
      display += '_'
    end
    display += " "
  end
  puts display
  puts "Guessed so far: #{guessed_letters.join}"
  puts "Number of mistakes left: #{num_mistakes_left}"
end

def get_guess(prev_guesses)
  guess = ''
  loop do 
    puts 'Guess a letter: '
    guess = gets.chomp.downcase[0]
    break if guess.match(/[a-z]/) && !prev_guesses.include?(guess)
  end
  guess
end

def game_over(word, guessed_letters, num_mistakes_left)
  return true if num_mistakes_left == 0
  word.each_char do |char|
    return false unless guessed_letters.include?(char)
  end
  return true # All characters have been guessed
end

dictionary = File.readlines('google-10000-english-no-swears.txt', chomp: true)
dictionary = dictionary.select {|word| word.length >=5 && word.length <=12}

word = dictionary.sample
guesses = []
num_mistakes_left = 15
while num_mistakes_left > 0 && !game_over(word, guesses, num_mistakes_left) do
  display_guesses(word, guesses, num_mistakes_left)
  guess = get_guess(guesses)
  guesses << guess
  if word.include?(guess)
    puts "That's a correct guess!"
  else
    puts("#{guess} was not in the word")
    num_mistakes_left -= 1
  end
end

if num_mistakes_left > 0
  puts "You guessed the whole word! #{word}"
else
  puts "You ran out of guesses. The word was #{word}"
end


