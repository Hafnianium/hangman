# frozen_string_literal: true

# generates a secret word
class SecretWord
  attr_reader :secret_word

  def initialize
    @dictionary = File.read('5desk.txt').split("\r\n")
    @secret_word = @dictionary[rand(@dictionary.length)].upcase
  end
end

# generates the underscores that slowly reveal the word
class Board
  attr_reader :secretword

  def initialize(secretword)
    @secretword = secretword
  end

  def display_string
    puts Array.new(secretword.secret_word.length, '_').join(' ')
  end
end

# takes player name and inputs guesses
class Player
  attr_reader :name
  attr_accessor :player_input, :guessed_letters

  def initialize
    puts 'Please enter your name.'
    @name = gets.chomp
    @guessed_letters = []
  end

  def input_letter
    puts 'Plase enter a letter'
    @i = 0
    while @i < 1
      @player_input = gets.chomp.upcase
      input_validation
    end
  end

  def input_validation
    if player_input !~ /[A-Z]/
      puts 'Please enter a LETTER.'
    elsif player_input.length > 1
      puts 'Please enter ONE letter.'
    elsif guessed_letters.any?(player_input)
      puts 'You have already guessed this letter.'
    else
      guessed_letters << player_input
      @i += 1
    end
  end
end

# instantiates the classes and starts the game
class GameRunner
  attr_reader :secretword, :board, :player

  def initialize
    @secretword = SecretWord.new
    @board = Board.new(secretword)
    @player = Player.new
    welcome_screen
    player.input_letter
  end

  def welcome_screen
    puts "Welcome to hangman #{player.name}! The secret word is #{secretword.secret_word.length} letters long."
    board.display_string
  end
end

GameRunner.new
