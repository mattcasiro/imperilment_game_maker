module GameBuilder 
  class Clue
    include Comparable
    attr_accessor :question, :answer, :value
    
    # Generates a Clue object
    #
    # @param q [String] is the question
    # @param a [String] is the answer to the question
    # @param v [Int] is the value of the clue (default: 0)
    def initialize(q, a, v=nil)
      @question = q
      @answer = a
      @value = v
    end

    # Compares two Clue objects based on their value
    #
    # @param other [Clue] is the other clue object to be compared
    def <=>(other)
      self.value <=> other.value
    end

    # Compare clues based on whether the contents are equal (eql?)
    #
    # @param other [Clue] is a Clue object to compare to
    def eql?(other)
      return false unless other.is_a?(Clue)
      (
        self.question == other.question &&
        self.answer == other.answer &&
        self.value == other.value
      )
    end
  end
end
