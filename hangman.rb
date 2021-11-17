class SecretWord
  attr_reader :secret_word
  def initialize
    @dictionary = File.read('5desk.txt').split("\r\n")
    @secret_word = @dictionary[rand(@dictionary.length)].upcase
  end
end

class Board
  attr_reader :secretword
  def initialize(secretword:)
    @secretword = secretword
    puts "Welcome to hangman! The secret word is #{secretword.secret_word.length} letters long."
  end

  def display_string
    puts Array.new(secretword.secret_word.length, '_').join(' ')
  end
end

Board.new(:secretword => SecretWord.new).display_string