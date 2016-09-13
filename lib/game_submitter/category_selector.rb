require 'game_builder/round'

module GameSubmitter
  class CategorySelector
    attr_reader :round
    LINK_STR = "a href="
    VDD_STR = "[Video Daily Double]"

    # Creates a cleaned round of jeopardy which only contains valid clues
    # A valid category must contain three or more valid clues.
    #
    # @param rnd [Round] a round from a valid game of Jeopardy.
    # @raise [ArgumentError] if the round contains no valid category.
    def initialize(rnd)
      @round = clean_round(rnd)
      raise ArgumentError, "Round is not valid" if round.categories.empty?
    end

    # Get a randomly selected category
    #
    # @param excluded_category [Category] a category that should not be selected
    # @param num [Int] overrides the random category with a specific selection
    def category excluded_category=nil, num=nil
      # Filter out excluded category to prevent duplication
      rnd = GameBuilder::Round.new(filter_category(excluded_category))
      raise ArgumentError, "Not enough categories" if rnd.categories.empty?

      num = (0...rnd.categories.count).to_a.sample unless num 
      rnd.categories[num]
    end

    private
    # Returns a new round that only contains valid categories as defined above
    def clean_round rnd
      GameBuilder::Round.new(valid_categories(rnd.categories))
    end

    # Returns an array of valid categories as defined above
    def valid_categories categories
      categories.map do |ctgry|
        tmp_ctgry = GameBuilder::Category.new(
          ctgry.name,
          clean_clues(ctgry.clues)
        )
        Cleaner.new.clean_category(tmp_ctgry)
      end.select { |ctgry| ctgry.clues.size >=3 }
    end

    # Returns an array clues with code and backslashes removed
    def clean_clues clues
      clues.map { |clue| Cleaner.new.clean_clue(clue) }
    end

    def filter_category filter
      return round.categories unless filter
      round.categories.reject{ |ctgry| ctgry.eql? filter }
    end
  end
end
