require 'game_submitter/cleaner'
require 'constants'

module GameSubmitter
  class ClueSelector
    # Generate a clue selector object
    #
    # @param clue_array [Array] an array of clues to select from
    def initialize clue_array
      @clues = clue_array
    end

    # Get a set of clues from the provided array
    #
    # @param level [Sym] determines which clues are selected
    # @returns [Array] an array of selected clues
    def select_clues
      if clues.size.eql?(1)
        # Handle Final Jeopardy exception
        [clues[0]]
      else
        case DIFFICULTY
        when :easy
          clues[0..2]
        when :medium, :hard
          clues[(clues.size - 3)..-1]
        else
          raise ArgumentError, "Invalid difficulty in constants.rb"
        end
      end
    end

    private
    attr_accessor :clues
  end
end
