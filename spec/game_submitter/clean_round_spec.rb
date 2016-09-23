require 'game_submitter/clean_round'
require 'game_builder/round'
require 'constants'

module GameSubmitter
  describe CleanRound do
    context "A round with some invalid categories and clues" do
      it "should only retain the good data" do
        dirty_categories = [
          GameBuilder::Category.new('One', [
            GameBuilder::Clue.new('Test1', 'Test1', 100),
            GameBuilder::Clue.new('Test2', 'Test2', 200),
            GameBuilder::Clue.new('Test3', 'Test3', 300),
            GameBuilder::Clue.new('Test4', 'Test4 <a href="">link</a>', 400),
            GameBuilder::Clue.new('Test5 [Video Daily Double]', 'Test5', 500),
          ]),
          GameBuilder::Category.new('Two', [
            GameBuilder::Clue.new('Test1', 'Test1', 100),
            GameBuilder::Clue.new('Test2', 'Test2', 200),
            GameBuilder::Clue.new('Test3', nil, 300),
            GameBuilder::Clue.new(nil, 'Test4', 400),
            GameBuilder::Clue.new(nil, nil, 500),
          ]),
        ]

        clean_round = GameBuilder::Round.new([
          GameBuilder::Category.new('One', [
            GameBuilder::Clue.new('Test1', 'Test1', 100),
            GameBuilder::Clue.new('Test2', 'Test2', 200),
            GameBuilder::Clue.new('Test3', 'Test3', 300),
          ]),
        ])

        expect(CleanRound.new(dirty_categories)).to eql(clean_round)
      end

      it "should remove backslashes and HTML tags from clues" do
        dirty_categories = [
          GameBuilder::Category.new('One', [
            GameBuilder::Clue.new('<i>Italics</i>', 'Test1', 100),
            GameBuilder::Clue.new('Test2', '<b>Bold</b>', 200),
            GameBuilder::Clue.new('Backslash\\', 'Double  Space', 300),
          ]),
        ]

        clean_round = GameBuilder::Round.new([
          GameBuilder::Category.new('One', [
            GameBuilder::Clue.new('Italics', 'Test1', 100),
            GameBuilder::Clue.new('Test2', 'Bold', 200),
            GameBuilder::Clue.new('Backslash', 'Double Space', 300),
          ]),
        ])

        expect(CleanRound.new(dirty_categories)).to eql(clean_round)
      end
    end

    context "A round with no valid categories" do
      it "should raise an ArgumentError" do
        bad_categories = [
          GameBuilder::Category.new('One', [
            GameBuilder::Clue.new('Test1', 'Test1', 100),
            GameBuilder::Clue.new('Test2', 'Test2', 200),
            GameBuilder::Clue.new('Test3 Q', 'Test3 <a href="">A</a>', 300),
            GameBuilder::Clue.new('Test4[Video Daily Double]A', 'Test4 A', 400),
          ]),
          GameBuilder::Category.new('Two', [
            GameBuilder::Clue.new('Test1', 'Test1', 100),
            GameBuilder::Clue.new('Test2', 'Test2', 200),
            GameBuilder::Clue.new('Test3', nil, 300),
            GameBuilder::Clue.new(nil, 'Test4', 400),
            GameBuilder::Clue.new(nil, nil, 500),
          ]),
        ]
        expect{ CleanRound.new(bad_categories) }.to raise_error(ArgumentError)
      end
    end

    context "A final round with an invalid clue" do
      it "should raise an ArgumentError" do
        bad_final = [
          GameBuilder::Category.new('One', [
            GameBuilder::Clue.new('Test1', nil, 100),
          ]),
        ]
        expect{ CleanFinalRound.new(bad_final) }.to raise_error(ArgumentError)
      end
    end
  end
end
