module Sayable
  def say(sentence)
    puts "#{sentence}"
  end
end

class Hand
  include Comparable

  attr_accessor :value

  def initialize(v)
    @value = v
  end

  def <=>(another_hand)
    if self.value == another_hand.value
      0
    elsif (self.value == 'R' && another_hand.value == 'S') || (self.value == 'P' && another_hand.value == 'R') || (self.value == 'S' && another_hand.value == 'P')
      1
    else
      -1
    end
  end
end

class Player
  attr_accessor :name, :hand

  def initialize(n)
    @name = n
  end

  def pick_hand
    self.hand = Hand.new(Game::CHOICES.keys.sample)
  end

  def to_s
    "#{name} picked #{Game::CHOICES[self.hand.value]}."
  end
end

class Computer < Player
end

class Human < Player
  include Sayable

  def pick_hand
    begin
      say "Pick one: (P, R, S)"
      choice = gets.chomp.upcase
    end until Game::CHOICES.keys.include?(choice)

    self.hand = Hand.new(choice)
  end

  def play_again?
    say "Play again? (Y/N)"
    response = gets.chomp.upcase
    response == "Y"
  end
end

class Game
  include Sayable
  
  attr_accessor :computer, :player

  CHOICES = { 'P' => 'Paper', 'R' => 'Rock', 'S' => 'Scissors'}

  def initialize
    @computer = Player.new("Computer")
    @player = Human.new("Bob")
  end

  def greeting(player)
    say "Hello #{player.name}!  Welcome to Paper, Rock, and Scissors!"
  end

  def compare_hands
    player_hand = self.player.hand
    computer_hand = self.computer.hand

    case 
    when computer_hand == player_hand
      say "It's a tie!"
    when computer_hand > player_hand
      say "Computer won!"
    else
      say "You won!"
    end
  end

  def play
    greeting(self.player)
    continue = true
    while continue
      self.computer.pick_hand
      self.player.pick_hand
      say self.player
      say self.computer
      compare_hands
      continue = self.player.play_again?
    end
  end
end

game = Game.new
game.play