require 'game_submitter/category_selector'
require 'constants'

module GameSubmitter

  describe CategorySelector do

    let(:game_1) { GameBuilder::Scraper.new.new_game!(FIXTURE_PATH + 'show_1_id_173_S1E1.html') }
    let(:game_337) { GameBuilder::Scraper.new.new_game!(FIXTURE_PATH + 'show_337_id_4260.html') }
    let(:game_383) { GameBuilder::Scraper.new.new_game!(FIXTURE_PATH + 'show_383_id_4279.html') }
    let(:game_6474) { GameBuilder::Scraper.new.new_game!(FIXTURE_PATH + 'show_6474_id_4010.html') }

    context "A round without any valid categories" do
      it "should raise an ArgumentError" do
        expect { CategorySelector.new(game_383.rounds[0]) }.to raise_error(ArgumentError)
      end
    end

    context "A video daily double clue, but no link" do
      let(:round) { CategorySelector.new(game_337.rounds[0]).round }

      it("removes the clue") do
        expect(round.categories[1].clues.size).to eql(4)
      end
    end

    context "A clue with a link in the answer" do
      let(:round) { CategorySelector.new(game_6474.rounds[1]).round }

      it("removes the clue") do
        expect(round.categories[1].clues.size).to eql(3)
      end
    end

    describe "#category" do
      context "Round[1] Category[0] of game 383" do
        let(:category) { CategorySelector.new(game_383.rounds[1]).category(nil, 0) }

        it("should have 3 valid clues") { expect(category.clues.size).to eql(3) }
        it("should correctly sort clues") { expect(category.clues.sort).to eql(category.clues) }

        context "When excluding a category" do
          it "should return a different category" do
            expect(CategorySelector.new(game_383.rounds[1]).category(category, 0)).not_to eql(category)
          end

          it "should raise an error if no categories remain" do
            expect { CategorySelector.new(GameBuilder::Round.new([category])).category(category) }.to raise_error(ArgumentError)
          end
        end
      end
    end

    describe "A clue with html tags and backspaces" do
      let(:question) { CategorySelector.new(game_1.rounds[0]).category(nil, 0).clues[0].question }

      it { expect(question).to eq("the Jordan") }
    end
  end
end
