require 'game_submitter/category_selector'
require 'game_builder/scraper'
require 'constants'

module GameSubmitter
  describe CategorySelector do
    let(:scraper) { GameBuilder::Scraper.new }
    let(:g_348) { scraper.new_game!(FIXTURE_PATH + 'show_348_id_4271.html') }
    let(:g_383) { scraper.new_game!(FIXTURE_PATH + 'show_383_id_4279.html') }

    context "A round without any valid categories" do
      let(:selector) { CategorySelector.new(g_383.rounds[0]) }

      it "raises an error" do
        expect { selector }.to raise_error(ArgumentError, /Round is not valid/)
      end
    end

    context "A round with some invalid categories" do
      let(:round) { g_383.rounds[1] }
      let(:ctgrys) { round.categories }
      let(:expected) do
        GameBuilder::Round.new([
          GameBuilder::Category.new(ctgrys[0].name, ctgrys[0].clues[2..4]),
          GameBuilder::Category.new(ctgrys[1].name, ctgrys[1].clues[2..4]),
          GameBuilder::Category.new(ctgrys[4].name, ctgrys[4].clues),
        ])
      end

      it "should reject the invalid categories" do
        expect(CategorySelector.new(round).round).to eql(expected)
      end
    end

    describe "#category" do
      context "given round[1] of game 383" do
        let(:round) { g_383.rounds[1] }
        let(:cln) do
          clnr = Cleaner.new
          [
            clnr.clean_category(round.categories[0]),
            clnr.clean_category(round.categories[1]),
            clnr.clean_category(round.categories[4]),
          ]
        end
        subject { CategorySelector.new(round) }

        it "properly selects a valid category" do
          expect(subject.category).to eql(cln[0]).or eql(cln[1]).or eql(cln[2])
        end
        it "allows manual selections" do
          expect(subject.category(nil, 0)).to eql(cln[0])
        end
        it "correctly sorts clues" do
          ctgry = subject.category(0)
          expect(ctgry.clues.sort).to eql(ctgry.clues)
        end
        it "correctly excludes categories" do
          rnd = GameBuilder::Round.new(round.categories[0..1])
          selector = CategorySelector.new(rnd)
          expect(selector.category(cln[0])).to eql(cln[1])
        end
        it "allows manual selection and exclusion" do
          expect(subject.category(cln[1], 1)).to eql(cln[2])
        end
      end

      context "given round[1] of game 348" do
        let(:round) { g_348.rounds[1] }
        let(:filter) { Cleaner.new.clean_category(round.categories[5]) }
        subject { CategorySelector.new(round).category(filter) }

        it "should raise an error if no categories remain" do
          expect {subject}.to raise_error(ArgumentError, /Not enough cat/)
        end
      end
    end
  end
end
