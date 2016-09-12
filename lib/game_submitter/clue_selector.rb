module GameSubmitter
  class ClueSelector
    # Generate a clue selector object
    #
    # @param clue_array [Array] an array of clues to select from
    # @param level [:easy, :medium, or :hard] dete
    def initialize clue_array
      @clue_array = clue_array
      @level = level
    end

    def clues level=:easy
      case level
      when :easy
        clue_array[0..2]
      when :medium, :hard
        clue_array[(clue_array.size - 3)..-1]
      else
        raise ArgumentError, "Invalid difficulty, use :easy, :medium, or :hard"
      end
    end
    private
    attr_accessor :clue_array, :level
  end
end
