require 'game_builder/category'
require 'constants'

module GameSubmitter
  class Cleaner
    # Remove HTML tags, backslashes, and consecutive whitespace from
    # clue questions and answers
    #
    # @param clue [Clue] is the clue to be cleaned
    # @returns [Clue] a new, cleaned, clue object
    def clean_clue clue
      clue.answer = remove_code(clue.answer) unless clue.answer.nil?
      clue.question = remove_code(clue.question) unless clue.question.nil?
      clue
    end

    # Remove clues containing any media links or Video Daily Doubles
    #
    # @param category [Category] is the category to be cleaned
    # @returns [Category] a new, cleaned, category object
    def clean_category category
      clues = category.clues.reject { |clue| invalid_clue? clue }
      GameBuilder::Category.new(category.name, clues)
    end

    private
    def remove_code str
      str.gsub(/\\/,'').gsub(/<.*>([^<]*)<.*>/, '\1').gsub(/[ ]{2,}/, ' ')
    end

    def invalid_clue? clue
      clue.answer.nil? ||                   # nil answer
      clue.question.nil? ||                 # nil question
      clue.answer&.include?(LINK_STR) ||    # link in answer
      clue.question&.include?(LINK_STR) ||  # link in question
      clue.answer&.include?(VDD_STR) ||     # video daily double in answer
      clue.question&.include?(VDD_STR)      # video daily double in question
    end
  end
end
