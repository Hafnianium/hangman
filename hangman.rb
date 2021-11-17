module SerializeObject
  require 'yaml'

  def self.deserialize(yaml_string)
    YAML::load(yaml_string)
  end

  def serialize
    YAML::dump(self)
  end
end

class Board
  include SerializeObject
  @@dictionary = File.read('5desk.txt').split("\r\n")

  attr_accessor :secret_word, :correct_letters, :incorrect_letters, :display_string, :hangman_board, :new_game, :new_player

  def initialize
    @secret_word = @@dictionary[rand(@@dictionary.length)].upcase.split('')
    @correct_letters = []
    @incorrect_letters = []
    @display_string = Array.new(@secret_word.length, '_')

    puts "The secret word is #{@secret_word.length} letters long."
  end

end

class Player
  include SerializeObject
  attr_accessor :name, :guessed_letters, :player_input, :new_game, :new_player, :hangman_board

  def initialize(name)
    @name = name
    @guessed_letters = []
    @player_input = ''

    puts "Welcome #{@name}."
  end

  def input_letter
    loop do
      letter = gets.chomp.upcase
      if letter == 'SAVE'
        save_game
        puts 'saving'
      elsif letter !~ /[A-Z]/
        puts 'Please enter a LETTER'
      elsif letter.length > 1
        puts 'Please enter ONE letter'
      elsif guessed_letters.any?(letter)
        puts 'You have already guessed this letter.'
      else
        @guessed_letters << letter
        @player_input = letter
        break
      end
    end
  end

  def save_game
    File.open("hangman_save.txt", "w"){|file| file.puts hangman_board.serialize, new_player.serialize, new_game.serialize}
    puts 'Game saved'
  end
end

class Game
  include SerializeObject
  attr_accessor :new_player, :hangman_board, :new_game

  def initialize
    puts 'Welcome to hangman! Please enter your name.'
    player_name = gets.chomp.to_s
    @new_player = Player.new(player_name)
    @hangman_board = Board.new
    @guesses = 0
    puts "You have #{10 - @guesses} guesses to get the word"
    puts hangman_board.display_string.join(' ')
    puts "\n"
  end

  def play_game
    loop do
      if hangman_board.display_string.join('') == hangman_board.secret_word.join('')
        you_win
        break
      elsif @guesses == 10
        you_lose
        break
      else
        new_player.input_letter
        if hangman_board.secret_word.any?(new_player.player_input)
          puts "Correct! #{new_player.player_input} is present"
          update_display_string
        else
          puts "Incorrect. #{new_player.player_input} is not present"
          @guesses += 1
        end
        puts "You have #{10 - @guesses} guesses left"
        puts hangman_board.display_string.join(' ')
        puts "\n"
      end
    end
  end

  def you_win
    puts "YOU WIN the word was #{hangman_board.secret_word.join('')}"
  end

  def you_lose
    puts "You LOSE! The word was #{hangman_board.secret_word.join('')}"
  end

  def update_display_string
    hangman_board.secret_word.each_with_index do |element, index|
      hangman_board.display_string[index] = new_player.player_input if element == new_player.player_input
    end
  end
end

new_game = Game.new
new_game.play_game
