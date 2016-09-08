require 'build_game'

describe BuildGame do
  context "Given the wrong number of sources" do
    it "raises an ArgumentError" do
      expect{ BuildGame.new(1, []) }.to raise_error(ArgumentError)
    end
  end

  context "Given a source with missing rounds" do
    it "raises a MissingRoundError" do
      expect{ BuildGame.new(1, ["spec/game_builder/fixtures/show_366_id_4284.html"]) }.to raise_error(GameBuilder::MissingRoundError)
    end
  end

  context "given a single game" do
    subject { BuildGame.new(1, ["spec/game_builder/fixtures/show_465_id_4788.html"]).games }

    it "builds an array of size one" do
      expect(subject.size).to eql(1)
      expect(subject.first.class).to eql(Array)
    end

    it "has three categories" do
      expect(subject.first.size).to eql(3)
      subject.first.each { |ca| expect(ca.class).to eql(GameBuilder::Category) }
    end

    it "has at least three clues in the first two categories" do
      expect(subject[0][0].clues.size).to be >= 3
      expect(subject[0][1].clues.size).to be >= 3
    end

    it "has one clue in the last category" do
      expect(subject[0][2].clues.size).to eql(1)
    end

    context "given two games" do
      subject do
        sources = [
          "spec/game_builder/fixtures/show_465_id_4788.html",
          "spec/game_builder/fixtures/show_2121_id_1426_S10.html"
        ]
        BuildGame.new(2, sources).games
      end

      it "builds an array of two arrays" do
        expect(subject.size).to eql(2)
        subject.each { |ar| expect(ar.class).to eql(Array) }
      end

      context "each sub-array" do
        it "has three categories" do
          subject.each { |ar| expect(ar.size).to eql(3) }
          subject.each { |ar| ar.each { |ca| expect(ca.class).to eql(GameBuilder::Category) } }
        end

        it "has at least three clues in the first two categories" do
          expect(subject[0][0].clues.size).to be >= 3
          expect(subject[0][1].clues.size).to be >= 3
        end

        it "has one clue in the last category" do
          expect(subject[0][2].clues.size).to eql(1)
          expect(subject[1][2].clues.size).to eql(1)
        end
      end
    end

    context "given two of the same games" do
      subject do
        sources = [
          "spec/game_builder/fixtures/show_465_id_4788.html",
          "spec/game_builder/fixtures/show_465_id_4788.html",
        ]
        BuildGame.new(2, sources).games
      end
      it "will only accept the first game" do
        expect{subject.sizei}.to raise_error(BuildGame::DuplicateGameError)
      end
    end
  end
end
