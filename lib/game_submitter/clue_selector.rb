require 'game_submitter/cleaner'

module GameSubmitter
  class ClueSelector
    # Generate a clue selector object
    #
    # @param clue_array [Array] an array of clues to select from
    def initialize clue_array
      @clues = clean_clues clue_array
      @level = level
    end

    # Get a set of clues from the provided array
    #
    # @param level [Sym] determines which clues are selected
    # @returns [Array] an array of selected clues
    def select_clues level=:easy
      case level
      when :easy
        clues[0..2]
      when :medium, :hard
        clues[(clues.size - 3)..-1]
      else
        raise ArgumentError, "Invalid difficulty, use :easy, :medium, or :hard"
      end
    end

    private
    attr_accessor :clues, :level

    def clean_clues clues
      clues.map do |clue|
        Cleaner.new.clean_clue clue
      end
    end
  end
end
