require 'game_builder/round'

module GameSubmitter
  class CleanRound
    def initialize dirty_categories
      @dirty_categories = dirty_categories
      
      raise ArgumentError, "No valid categories" if categories.empty?
    end

    def categories
      valid_categories
    end

    # Compare rounds based on whether the categories are equal (eql?)
    #
    # @param other [Round] is a Round object to compare to
    def eql?(other)
      if other.is_a?(CleanRound) || other.is_a?(GameBuilder::Round)
        return self.categories.eql?(other.categories)
      end
      false
    end

    protected
    def clean_categories
      dirty_categories.map do |dirty_category|
        # Remove clues containing any media links or Video Daily Doubles
        clues = dirty_category.clues.reject { |clue| invalid_clue? clue }
        GameBuilder::Category.new(dirty_category.name, clean_clues(clues))
      end
    end

    def valid_categories
      clean_categories.select { |category| category.clues.size >= 3 }
    end

    # Remove HTML tags, backslashes, and consecutive whitespace
    def clean_clues clues
      clues.map do |clue|
        answer = remove_code(clue.answer)
        question = remove_code(clue.question)
        GameBuilder::Clue.new(question, answer, clue.value)
      end
    end

    def invalid_clue? clue
      clue.answer.nil? ||                   # nil answer
      clue.question.nil? ||                 # nil question
      clue.answer&.include?(LINK_STR) ||    # link in answer
      clue.question&.include?(LINK_STR) ||  # link in question
      clue.answer&.include?(VDD_STR) ||     # video daily double in answer
      clue.question&.include?(VDD_STR)      # video daily double in question
    end

    def remove_code str
      str.gsub(/\\/,'').gsub(/<.*>([^<]*)<.*>/, '\1').gsub(/[ ]{2,}/, ' ')
    end

    private
    attr_reader :dirty_categories
  end

  class CleanFinalRound < CleanRound
    protected
    def valid_categories
      clean_categories.select { |category| category.clues.size == 1 }
    end
  end
end
