require 'game_submitter/clue_selector'
require 'game_builder/scraper'
require 'constants'

module GameSubmitter
  describe ClueSelector do
    context "Given five clues on easy difficulty" do
      let(:clues) { GameBuilder::Scraper.new.new_game!(FIXTURE_PATH + "show_465_id_4788.html").rounds[0].categories[3].clues }
      let(:selector) { ClueSelector.new(clues) } 

      it { expect(selector.select_clues).to be_an_instance_of(Array) }
      it { expect(selector.select_clues.size).to be(3) }
      it "should select the first three clues" do
        stub_const("DIFFICULTY", :easy)
        expect(selector.select_clues).to eql(clues[0..2])
      end
    end

    context "Given different difficulties" do
      let(:clues) { GameBuilder::Scraper.new.new_game!(FIXTURE_PATH + "show_465_id_4788.html").rounds[0].categories[3].clues }
      let(:selector) { ClueSelector.new(clues) } 

      it "should select last three clues on medium" do
        stub_const("DIFFICULTY", :medium)
        expect(selector.select_clues).to eql(clues[2..4])
      end
      it "should select last three clues on hard" do
        stub_const("DIFFICULTY", :hard)
        expect(selector.select_clues).to eql(clues[2..4])
      end
      it "should raise and error give an invalid difficulty" do
        stub_const("DIFFICULTY", :ez)
        expect{ selector.select_clues }.to raise_error(ArgumentError)
      end
    end
  end
end
