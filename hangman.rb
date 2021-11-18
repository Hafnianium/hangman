# frozen_string_literal: true

require 'yaml'

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

# takes player name and stores guesses
class Player
  attr_reader :name
  attr_accessor :guessed_letters

  def initialize
    puts 'Please enter your name.'
    @name = gets.chomp
    @guessed_letters = []
  end
end

# instantiates the classes and starts the game
class GameRunner
  attr_reader :secretword, :board, :player
  attr_accessor :guesses, :player_input, :game_saved

  def initialize
    @secretword = SecretWord.new
    @board = Board.new(secretword)
    @player = Player.new
    @guesses = 0
    @game_saved = 'No'
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

  def input_letter
    puts 'Please enter a letter.'
    @i = 0
    while @i < 1
      @player_input = gets.chomp.upcase
      if player_input == 'SAVE'
        save_game
        break
      else
        input_validation
      end
    end
  end

  def input_validation
    if player_input !~ /[A-Z]/
      puts 'Please enter a LETTER.'
    elsif player_input.length > 1
      puts 'Please enter ONE letter.'
    elsif player.guessed_letters.any?(player_input)
      puts 'You have already guessed this letter.'
    else
      player.guessed_letters << player_input
      @i += 1
    end
  end

  def play_game
    @x = 0
    while @x < 1
      if @guesses == 10
        puts "You lose! The secret word was #{secretword.secret_word}."
      elsif board.secret_word_array == board.secret_word_display_array
        puts "You win! The secret word was #{secretword.secret_word}"
      else
        input_letter
        if game_saved == 'No'
          guess_check
          update_display_string
          board.display_string
        end
      end
    end
  end

  def save_game
    puts 'Saving game.'
    @game_saved = 'Yes'
    @x += 1
    File.open('hangman_save.txt', 'w'){ |file| file.puts serialize_object }
    puts 'Game saved.'
  end

  def serialize_object
    YAML::dump(self)
  end
end

GameRunner.new
