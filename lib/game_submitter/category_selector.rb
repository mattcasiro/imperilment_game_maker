require 'game_builder/category'
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
    # @raise [ArgumentError] if the round does not contain at least one valid category.
    def initialize(rnd)
      @round = clean_round(rnd)
      raise ArgumentError, "Round is not valid" if round.categories.empty?
    end

    # Get a randomly selected category
    #
    # @param excluded_category [Category] a category that should not be selected
    # @param num [Int] overrides the random category with a specific selection
    def category excluded_category=nil, num=nil
      # Reject matching category to prevent duplicates
      tmp_rnd = if excluded_category
        GameBuilder::Round.new(round.categories.reject { |category| category.eql? excluded_category })
      end || round
      raise ArgumentError, "Not enough categories" if tmp_rnd.categories.empty?
      num = (0...tmp_rnd.categories.count).to_a.sample unless num

      tmp_rnd.categories[num]
    end

    private
    # Returns a new round that:
    #   - Only contains three valid clues
    #   - Only contains valid categories as defined above
    def clean_round round
      valid_categories = round.categories.map do |category|
        valid_clues = category.clues.select { |clue| !invalid_clue? clue }
        category = GameBuilder::Category.new(category.name, clean_clues(valid_clues))
      end.select { |category| category.clues.size >= 3 }

      GameBuilder::Round.new(valid_categories)
    end

    # Returns true if the clue is NOT valid
    def invalid_clue? clue
      clue.answer.nil? ||                   # nil answer
      clue.question.nil? ||                 # nil question
      clue.answer&.include?(LINK_STR) ||    # link in answer
      clue.question&.include?(LINK_STR) ||  # link in question
      clue.answer&.include?(VDD_STR)        # video daily double (no link)
    end

    def clean_clues clues
      clues.map do |clue|
        clue.answer = remove_code(clue.answer)
        clue.question = remove_code(clue.question)
        clue
      end
    end

    def remove_code str
      str.gsub(/\\/,'').gsub(/<.*>([^<]*)<.*>/, '\1').gsub(/[ ]{2,}/, ' ')
    end
  end
end
