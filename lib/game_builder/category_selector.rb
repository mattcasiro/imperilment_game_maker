module GameBuilder
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
    # @param num [Int] overrides the random category with a specific selection
    def category(num=(0...round.categories.count).to_a.sample)
      round.categories[num]
    end

    private
    # Returns a new round that:
    #   - Only contains three valid clues
    #   - Only contains valid categories as defined above
    def clean_round round
      valid_categories = round.categories.map do |category|
        valid_clues = category.clues.select { |clue| !invalid_clue? clue }
        category = Category.new(category.name, clean_clues(valid_clues))
      end.select { |category| category.clues.size >= 3 }

      Round.new(valid_categories)
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
        clue.answer = remove_html(clue.answer)
        clue.question = remove_html(clue.question)
        clue
      end
    end

    def remove_html str
      str.gsub(/\\/,'').gsub(/<.*>([^<]*)<.*>/, '\1').gsub(/[ ]{2,}/, ' ')
    end
  end
end
