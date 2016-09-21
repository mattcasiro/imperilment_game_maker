require 'game_builder/round'
require 'game_submitter/cleaner'
require 'pry'

module GameSubmitter
  class CategorySelector
    attr_reader :round

    # Creates a cleaned round of jeopardy which only contains valid clues
    # A valid category must contain three or more valid clues.
    #
    # @param rnd [Round] a round from a valid game of Jeopardy.
    # @raise [ArgumentError] if the round contains no valid category.
    def initialize(rnd, final=false)
      @round = clean_round(rnd, final)
      raise ArgumentError, "Round is not valid" if round.categories.empty?
    end

    # Get a randomly selected, cleaned category
    #
    # @param excluded_category [Category] a category that should not be selected
    # @param num [Int] overrides the random category with a specific selection
    # @raise [ArgumentError] if there are not enough categories to choose from
    def category excluded_category=nil, num=nil
      # Filter out excluded category to prevent duplication
      rnd = GameBuilder::Round.new(filter_category(excluded_category))
      raise ArgumentError, "Not enough categories" if rnd.categories.empty?

      num = (0...rnd.categories.count).to_a.sample unless num 
      rnd.categories[num]
    end

    # Returns a cleaned duplicate of the Final Jeopardy category
    def final_category
      if round.categories.size != 1 || round.categories[0].clues.size != 1
        raise RuntimeError, "Round does not appear to be a Final Jeopardy"
      end
      round.categories[0]
    end

    private
    # Returns a new round that only contains valid categories as defined above
    def clean_round rnd, final
      min = final ? 1 : 3
      GameBuilder::Round.new(valid_categories(rnd.categories, min))
    end

    # Returns an array of valid categories as defined above
    def valid_categories categories, min
      categories.map do |ctgry|
        tmp_ctgry = GameBuilder::Category.new(
          ctgry.name,
          clean_clues(ctgry.clues)
        )
        Cleaner.new.clean_category(tmp_ctgry)
      end.select { |ctgry| ctgry.clues.size >= min }
    end

    # Returns an array of clues with code and backslashes removed
    def clean_clues clues
      clues.map { |clue| Cleaner.new.clean_clue(clue) }
    end

    def filter_category filter
      return round.categories unless filter
      round.categories.reject{ |ctgry| ctgry.eql? filter }
    end
  end
end
