# frozen_string_literal: true

require 'colorize'
require 'json'

# This game is fairly simple. The whole thing goes in this single Game class,
# except the main game menu which goes in Launcher.
class Game
  def initialize
    self.word = random_word
    self.good_letters = []
    self.bad_letters = []
    self.errors_left = word.length * 2
  end

  def main_loop
    until game_over?
      display
      print 'Enter a letter or a command: '
      handle_input(gets.chomp)
    end

    game_over
  end

  private

  attr_accessor :word, :good_letters, :bad_letters, :errors_left

  def random_word
    File.readlines('./assets/dict.txt').collect(&:chomp).select { |word| word.length.between?(5, 12) }.sample
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
    File.open('./savefile', 'w') do |savefile|
      savefile.puts json
    end
    puts 'Saved to savefile.'
  end

  def resume
    data = JSON.load_file('./savefile')
    self.word = data['word']
    self.good_letters = data['good_letters']
    self.bad_letters = data['bad_letters']
    self.errors_left = data['errors_left']
    puts 'Resumed from savefile.'
  end

  def good_letter_input(letter)
    good_letters << letter unless good_letters.include?(letter)
  end

  def bad_letter_input(letter)
    self.errors_left -= 1 unless bad_letters.include?(letter)
    bad_letters << letter unless bad_letters.include?(letter)
  end

  def command_input(command)
    case command
    when 'save'
      save
    when 'resume'
      resume
    when 'exit'
      exit
    end
  end

  def handle_input(input)
    valid_commands = %w[save resume exit]
    if valid_commands.include?(input)
      command_input(input)
    elsif word.include?(input)
      good_letter_input(input)
    else
      bad_letter_input(input)
    end
  end

  def word_found?
    good_letters.length == word.chars.uniq.length
  end

  def game_over?
    word_found? || errors_left <= 0
  end

  def game_over
    if word_found?
      puts "You found the word '#{word}'! You win!"
    else
      puts "You lose! The word was '#{word}."
    end

    exit
  end
end
