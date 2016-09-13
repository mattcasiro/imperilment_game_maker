require 'game_submitter/cleaner'

module GameSubmitter
  describe Cleaner do
    describe "#clean_clue" do
      context "A nil clue" do
        let(:nil_clue) { GameBuilder::Clue.new(nil, nil, nil) }

        it { expect(Cleaner.new.clean_clue(nil_clue)).to eql(nil_clue) }
      end

      context "A clue with html tags and backspaces" do
        let(:expected) { GameBuilder::Clue.new(
          "An answer with html tags ' and backslashes",
          "A question with html tags and backslashes") }
        let(:clue) { GameBuilder::Clue.new(
          "An answer with <i>html tags</i> \\ \' and backslashes",
          "A question with <p>html tags</p> and \\\\ backslashes") }

        it { expect(Cleaner.new.clean_clue(clue)).to eql(expected) }
      end
    end

    describe "#clean_category" do
      context "cleaning invalid clues" do
        let(:base_clues){(0..2).map{|i| GameBuilder::Clue.new("#{i}", "#{i}") }}
        let(:expected) { GameBuilder::Category.new("Tests", base_clues) }

        context "removes clues with nil data" do
          let(:clues) do
            tmp = base_clues.dup
            tmp << GameBuilder::Clue.new(nil, "")
            tmp << GameBuilder::Clue.new("", nil)
          end
          let(:category) { GameBuilder::Category.new("Tests", clues) }

          it { expect(Cleaner.new.clean_category(category)).to eql(expected) }
        end

        context "removes clues with video daily double" do
          let(:clues) do
            tmp = base_clues.dup
            tmp << GameBuilder::Clue.new(VDD_STR, "")
            tmp << GameBuilder::Clue.new("", VDD_STR)
          end
          let(:category) { GameBuilder::Category.new("Tests", clues) }

          it { expect(Cleaner.new.clean_category(category)).to eql(expected) }
        end

        context "removes clues with a link" do
          let(:clues) do
            tmp = base_clues.dup
            tmp << GameBuilder::Clue.new(LINK_STR, "")
            tmp << GameBuilder::Clue.new("", LINK_STR)
          end
          let(:category) { GameBuilder::Category.new("Tests", clues) }

          it { expect(Cleaner.new.clean_category(category)).to eql(expected) }
        end
      end
    end
  end
end
