require 'game_builder/category'

module GameBuilder

  describe Category do

    subject { Category.new("name", "clue array") }

    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:clues) }

    let(:category1){ Category.new("name", [Clue.new("a", "b", 1), Clue.new("e", "f", 3)]) }
    let(:category2){ Category.new("eman", [Clue.new("c", "d", 2), Clue.new("e", "f", 3)]) }
    let(:category3){ Category.new("name", [Clue.new("a", "b", 1), Clue.new("e", "f", 3)]) }

    it "should only be equal with another category if they have the same content" do
      expect(category1).to eql(category3)
      expect(category1).not_to eql(category2)
    end
  end
end
