# frozen_string_literal: true

require 'colorize'
require 'json'

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

  # Main display method.
  # Display the word, substituting missing letters with '_', also display wrong letters.
  def display
    partial_word_array = word.chars.collect do |letter|
      if good_letters.include?(letter)
        letter
      else
        '_'
      end
    end

    puts "[#{partial_word_array.join(' ').colorize(:green)}] | [#{bad_letters.join(', ').colorize(:red)}]"
    puts "#{errors_left} mistakes left.".colorize(:red)
  end

  def save
    json = JSON.dump({ word: word, good_letters: good_letters, bad_letters: bad_letters, errors_left: errors_left })
    save_file = File.open('./savefile', 'w')
    save_file.puts json
  end

  def resume
    data = JSON.load_file('./savefile')
    self.word = data['word']
    self.good_letters = data['good_letters']
    self.bad_letters = data['bad_letters']
    self.errors_left = data['errors_left']
  end
end
