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
  attr_reader :secretword, :secret_word_array
  attr_accessor :secret_word_display_array

  def initialize(secretword)
    @secretword = secretword
    @secret_word_array = secretword.secret_word.split('')
    @secret_word_display_array = Array.new(secretword.secret_word.length, '_')
  end

  def display_string
    puts secret_word_display_array.join(' ')
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
  attr_accessor :guesses

  def initialize
    @secretword = SecretWord.new
    @board = Board.new(secretword)
    @player = Player.new
    @guesses = 0
    welcome_screen
    play_game
  end

  def welcome_screen
    puts "Welcome to hangman #{player.name}! The secret word is #{secretword.secret_word.length} letters long.
You have #{10 - guesses} guesses to get the word."
    board.display_string
  end

  def update_display_string
    board.secret_word_array.each_with_index do |element, index|
      board.secret_word_display_array[index] = player.guessed_letters[-1] if element == player.guessed_letters[-1]
    end
  end

  def guess_check
    if board.secret_word_array.any?(player.guessed_letters[-1])
      puts "Correct! #{player.guessed_letters[-1]} is present!"
    else
      @guesses += 1
      puts "Sorry! #{player.guessed_letters[-1]} is not present \n#{10 - @guesses} guesses remaining."
    end
  end

  def play_game
    loop do
      player.input_letter
      guess_check
      update_display_string
      board.display_string
    end
  end
end

GameRunner.new
