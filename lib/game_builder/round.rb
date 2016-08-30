require 'game_builder/category'

module GameBuilder
  class Round
    attr_reader :categories

    # Generate a Round object containing an array of Categories
    #
    # @param category_array [Category[]] is the array of categories that belong to this round
    def initialize(category_array)
      @categories = category_array
    end

    # Compare rounds based on whether the categories are equal (eql?)
    #
    # @param other [Round] is a Round object to compare to
    def eql?(other)
      return false unless other.is_a?(Round)
      self.categories.eql?(other.categories)
    end
  end
end
