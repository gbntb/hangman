# frozen_string_literal: true

# This game is fairly simple. The whole thing goes in this single Game class,
# except the main game menu which goes in Launcher.
class Game
  attr_accessor :word, :good_letters, :bad_letters, :errors_left

  def initialize(word, good_letters, bad_letters, errors_left)
    self.word = word
    self.good_letters = good_letters
    self.bad_letters = bad_letters
    self.errors_left = errors_left
  end
end
