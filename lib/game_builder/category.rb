require 'game_builder/clue'

module GameBuilder
  class Category
    include Comparable
    attr_reader :clues, :name

    # Generates a Category object
    #
    # @param name [String] is the category name
    # @param clue_array [Clue[]] is the array of clues belonging to this category
    def initialize(name, clue_array)
      @name = name
      @clues = clue_array
    end

    # Compare categories based on whether the clues are equal (eql?)
    #
    # @param other [Category] is a Category object to compare to
    def eql?(other)
      return false unless other.is_a?(Category)
      self.clues.eql?(other.clues) && self.name.eql?(other.name)
    end

    # Sort categories based on their name
    def <=>(other)
      self.name <=> other.name
    end
  end
end
