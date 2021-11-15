# need "board" class (guess count, correct letters, incorrect letters)
# player class
# game runner class

class Board
  @@dictionary = File.read('5desk.txt').split("\r\n")
  
  attr_accessor :secret_word
  
  def initialize
    @secret_word = @@dictionary[rand(@@dictionary.length)].upcase.split('')
    @correct_letters = []
    @incorrect_letters = []
    
    puts "The secret word is #{@secret_word.length} letters long."
  end
end

class Player
  attr_accessor :name, :guessed_letters

  def initialize(name)
    @name = name
    @guessed_letters = []
    
    puts "Welcome #{@name}."
  end

  def input_letter
    loop do
      letter = gets.chomp.upper
      if letter !~ /[A-Z]/
        puts 'Please enter a LETTER'
      elsif letter.length > 1
        puts 'Please enter ONE letter'
      elsif guessed_letters.any?(letter)
        puts 'You have already guessed this letter.'
      else
        break
      end
    end
    @guessed_letters << letter
    return letter
  end
end

class Game
  def initialize
    puts 'Welcome to hangman! Please enter your name.'
    player_name = gets.chomp.to_s
    Player.new('Patrick')
    Board.new
  end
end

Game.new
