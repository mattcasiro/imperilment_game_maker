require 'game_builder/scraper'
require 'constants'

class DuplicateGameError < StandardError
end

class BuildGame
  attr_reader :games

  def initialize(user_paths=nil)
    @user_paths = user_paths
    @sources = []
    @games = []
  end

  # Get a full game of Jeopardy from the web scraper.
  #
  # @POST: - The first user provided source is used and removed from the set,
  #          if the user provided sources
  #        - The game is added to 'games'
  #
  # @returns a game of jeopardy scraped from the web
  # @raise [ArgumentError] if the user provided sources array is empty
  # @raise [DuplicateGameError] if the game was already scraped
  def next_game!
    raise ArgumentError, "No more user_paths" if user_paths.eql?([])

    game = scrape_game(user_paths&.shift)
    raise DuplicateGameError if sources.include? game.source

    sources.push game.source
    games.push game
    games.last
  end

  private
  attr_reader :num_games, :user_paths, :sources

  def scrape_game(path)
    scraper = GameBuilder::Scraper.new
    begin
      path ? scraper.new_game!(path) : scraper.new_game!
    rescue GameBuilder::MissingRoundError => err
      raise err if user_paths
      retry
    end
  end
end
