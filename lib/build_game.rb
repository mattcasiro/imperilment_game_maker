require 'game_builder/scraper'
require 'game_builder/category'
require 'game_builder/category_selector'

class BuildGame
  class DuplicateGameError < StandardError
  end

  attr_reader :games

  def initialize(num=1, user_paths=nil)
    raise ArgumentError, "Incorrect number of user_paths" if user_paths &&
                                                             user_paths.size != num
    sources = []
    scraper = GameBuilder::JArchiveScraper.new
    @games = (0...num).map do |i|
      # Add a unique game to the set
      tmp = next_game(scraper, i, user_paths)
      if sources.include? tmp.source
        raise DuplicateGameError if user_paths
        redo
      end
      sources.push tmp.source

      rounds = begin
        # Reduce game to three categories (one per round)
        [
          r1 = GameBuilder::CategorySelector.new(tmp.rounds[0]).category,
          r2 = GameBuilder::CategorySelector.new(tmp.rounds[1]).category,
          r3 = tmp.rounds[2].categories.first
        ]
      rescue ArgumentError => err
        raise err if user_paths
        redo
      end
      # Reduce categories to three clues
      multiplier = 1
      rounds.map do |category|
        clues = category.clues.reject { |clue| clue.nil? }
        if clues.size > 2 then
          clues[0].value = 200 * multiplier
          clues[1].value = 600 * multiplier
          clues[2].value = 1000 * multiplier
        end
        multiplier += 1
        GameBuilder::Category.new category.name, clues[0..2]
      end
    end
  end

  private
  def next_game(scraper, i, user_paths)
    begin
      user_paths ? scraper.new_game!(user_paths[i]) : scraper.new_game!
    rescue GameBuilder::MissingRoundError => err
      raise err if user_paths
      retry
    end
  end
end
