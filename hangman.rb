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

# instantiates the classes and starts the game
class GameRunner
  attr_reader :secretword, :board

  def initialize
    @secretword = SecretWord.new
    @board = Board.new(secretword)
  end

  def welcome_screen
    puts "Welcome to hangman! The secret word is #{secretword.secret_word.length} letters long."
    board.display_string
  end
end

GameRunner.new.welcome_screen
