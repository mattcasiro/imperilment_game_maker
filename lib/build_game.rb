require 'game_builder/scraper'
require 'game_submitter/category_selector'

class BuildGame
  class DuplicateGameError < StandardError
  end

  # Set difficulty to determine the types of clues that are selected
  DIFFICULTY = :medium

  attr_reader :games

  def initialize(num=1, user_paths=nil)
    raise ArgumentError, "Incorrect number of user_paths" if user_paths &&
                                                             user_paths.size != num
    sources = []
    scraper = GameBuilder::Scraper.new
    @games = (0...num).map do |i|
      # Add a unique game to the set
      tmp = next_game(scraper, i, user_paths)
      if sources.include? tmp.source
        raise DuplicateGameError if user_paths
        redo
      end
      sources.push tmp.source

      rounds = begin
        i = (DIFFICULTY == :easy || DIFFICULTY == :medium) ? 0 : 1
        # Reduce game to three categories (one per round)
        [
          r1 = GameSubmitter::CategorySelector.new(tmp.rounds[i]).category,
          GameSubmitter::CategorySelector.new(tmp.rounds[1]).category(r1),
          tmp.rounds[2].categories.first
        ]
      rescue ArgumentError => err
        raise err if user_paths
        redo
      end
      # Reduce categories to three clues
      multiplier = 1
      rounds.map do |category|
        clues = category.clues.reject { |clue| clue.nil? }
        clues = clues[(clues.length % 3)..-1] if clues.length > 1 && (DIFFICULTY == :medium || DIFFICULTY == :hard)
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
