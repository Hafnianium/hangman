# need "board" class (guess count, correct letters, incorrect letters)
# player class
# game runner class

class Board
  @@dictionary = File.read('5desk.txt').split("\r\n")

  attr_accessor :secret_word, :correct_letters, :incorrect_letters, :display_string

  def initialize
    @secret_word = @@dictionary[rand(@@dictionary.length)].upcase.split('')
    @correct_letters = []
    @incorrect_letters = []
    @display_string = Array.new(@secret_word.length, '_').join(' ')

    puts "The secret word is #{@secret_word.length} letters long."
  end
end

class Player
  attr_accessor :name, :guessed_letters, :player_input

  def initialize(name)
    @name = name
    @guessed_letters = []
    @player_input = ''

    puts "Welcome #{@name}."
  end

  def input_letter
    loop do
      letter = gets.chomp.upcase
      if letter !~ /[A-Z]/
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
end

class Game
  attr_accessor :new_player, :hangman_board

  def initialize
    puts 'Welcome to hangman! Please enter your name.'
    player_name = gets.chomp.to_s
    @new_player = Player.new(player_name)
    @hangman_board = Board.new
    @guesses = 0
    puts "You have #{10 - @guesses} guesses to get the word"
    puts hangman_board.display_string
  end

  def play_game
    loop do
      if new_player.guessed_letters.sort == hangman_board.secret_word.sort
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
        puts hangman_board.display_string
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
      if element == new_player.player_input
        hangman_board.display_string[index] = new_player.player_input
      end
    end
  end
end

new_game = Game.new
new_game.play_game
