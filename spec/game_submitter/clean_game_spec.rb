require 'game_submitter/clean_game'
require 'game_builder/game'
require 'constants'

module GameSubmitter
  describe CleanGame do
    context "given a complete game" do
      let(:game) do
        GameBuilder::Game.new("clean_game_spec", [
          GameBuilder::Round.new([
            GameBuilder::Category.new("One", [
              GameBuilder::Clue.new("Test Q 1", "Test A 1", 100),
              GameBuilder::Clue.new("Test Q 2", "Test A 2", 200),
              GameBuilder::Clue.new("Test Q 3", "Test A 3", 300),
              GameBuilder::Clue.new("Test Q 4", "Test A 4", 400),
              GameBuilder::Clue.new("Test Q 5", "Test A 5", 500),
            ]),
          ]),
          GameBuilder::Round.new([
            GameBuilder::Category.new("Two", [
              GameBuilder::Clue.new("Test Q 1", "Test A 1", 100),
              GameBuilder::Clue.new("Test Q 2", "Test A 2", 200),
              GameBuilder::Clue.new("Test Q 3", "Test A 3", 300),
              GameBuilder::Clue.new("Test Q 4", "Test A 4", 400),
              GameBuilder::Clue.new("Test Q 5", "Test A 5", 500),
            ]),
          ]),
          GameBuilder::Round.new([
            GameBuilder::Category.new("Final", [
              GameBuilder::Clue.new("Test FQ", "Test FA"),
            ]),
          ]),
        ])
      end

      context EasyGame do
        let(:clean_game) do
          [
            GameBuilder::Category.new("One", [
              GameBuilder::Clue.new("Test Q 1", "Test A 1", 200),
              GameBuilder::Clue.new("Test Q 2", "Test A 2", 600),
              GameBuilder::Clue.new("Test Q 3", "Test A 3", 1000),
            ]),
            GameBuilder::Category.new("Two", [
              GameBuilder::Clue.new("Test Q 1", "Test A 1", 400),
              GameBuilder::Clue.new("Test Q 2", "Test A 2", 1200),
              GameBuilder::Clue.new("Test Q 3", "Test A 3", 2000),
            ]),
            GameBuilder::Category.new("Final", [
              GameBuilder::Clue.new("Test FQ", "Test FA"),
            ]),
          ]
        end

        it { expect(EasyGame.new(game).categories).to eql(clean_game) }

      end

      context MediumGame do
        let(:clean_game) do
          [
            GameBuilder::Category.new("One", [
              GameBuilder::Clue.new("Test Q 3", "Test A 3", 200),
              GameBuilder::Clue.new("Test Q 4", "Test A 4", 600),
              GameBuilder::Clue.new("Test Q 5", "Test A 5", 1000),
            ]),
            GameBuilder::Category.new("Two", [
              GameBuilder::Clue.new("Test Q 3", "Test A 3", 400),
              GameBuilder::Clue.new("Test Q 4", "Test A 4", 1200),
              GameBuilder::Clue.new("Test Q 5", "Test A 5", 2000),
            ]),
            GameBuilder::Category.new("Final", [
              GameBuilder::Clue.new("Test FQ", "Test FA"),
            ]),
          ]
        end

        it { expect(MediumGame.new(game).categories).to eql(clean_game) }
      end

      context HardGame do
        let(:clean_game) do
          [
            GameBuilder::Category.new("One", [
              GameBuilder::Clue.new("Test Q 3", "Test A 3", 200),
              GameBuilder::Clue.new("Test Q 4", "Test A 4", 600),
              GameBuilder::Clue.new("Test Q 5", "Test A 5", 1000),
            ]),
            GameBuilder::Category.new("Two", [
              GameBuilder::Clue.new("Test Q 3", "Test A 3", 400),
              GameBuilder::Clue.new("Test Q 4", "Test A 4", 1200),
              GameBuilder::Clue.new("Test Q 5", "Test A 5", 2000),
            ]),
            GameBuilder::Category.new("Final", [
              GameBuilder::Clue.new("Test FQ", "Test FA"),
            ]),
          ]
        end

        context "a game without two double jeopardy categories" do
          subject { HardGame.new(game).categories }
          it { expect{ subject }.to raise_error(ArgumentError) }
        end
        
        context "a game with two double jeopardy categories" do
          let(:hard_game) do
            GameBuilder::Game.new("clean_game_spec", [
              GameBuilder::Round.new([
                GameBuilder::Category.new("One", [
                  GameBuilder::Clue.new("Test Q 1", "Test A 1", 100),
                  GameBuilder::Clue.new("Test Q 2", "Test A 2", 200),
                  GameBuilder::Clue.new("Test Q 3", "Test A 3", 300),
                  GameBuilder::Clue.new("Test Q 4", "Test A 4", 400),
                  GameBuilder::Clue.new("Test Q 5", "Test A 5", 500),
                ]),
              ]),
              GameBuilder::Round.new([
                GameBuilder::Category.new("A(two)", [
                  GameBuilder::Clue.new("Test Q 1", "Test A 1", 100),
                  GameBuilder::Clue.new("Test Q 2", "Test A 2", 200),
                  GameBuilder::Clue.new("Test Q 3", "Test A 3", 300),
                  GameBuilder::Clue.new("Test Q 4", "Test A 4", 400),
                  GameBuilder::Clue.new("Test Q 5", "Test A 5", 500),
                ]),
                GameBuilder::Category.new("B(three)", [
                  GameBuilder::Clue.new("Test Q 1", "Test A 1", 100),
                  GameBuilder::Clue.new("Test Q 2", "Test A 2", 200),
                  GameBuilder::Clue.new("Test Q 3", "Test A 3", 300),
                  GameBuilder::Clue.new("Test Q 4", "Test A 4", 400),
                  GameBuilder::Clue.new("Test Q 5", "Test A 5", 500),
                ]),
              ]),
              GameBuilder::Round.new([
                GameBuilder::Category.new("C(final)", [
                  GameBuilder::Clue.new("Test FQ", "Test FA"),
                ]),
              ]),
            ])
          end
          let(:clean_hard_game) do
            [
              GameBuilder::Category.new("A(two)", [
                GameBuilder::Clue.new("Test Q 3", "Test A 3", 200),
                GameBuilder::Clue.new("Test Q 4", "Test A 4", 600),
                GameBuilder::Clue.new("Test Q 5", "Test A 5", 1000),
              ]),
              GameBuilder::Category.new("B(three)", [
                GameBuilder::Clue.new("Test Q 3", "Test A 3", 400),
                GameBuilder::Clue.new("Test Q 4", "Test A 4", 1200),
                GameBuilder::Clue.new("Test Q 5", "Test A 5", 2000),
              ]),
              GameBuilder::Category.new("C(final)", [
                GameBuilder::Clue.new("Test FQ", "Test FA"),
              ]),
            ]
          end
          subject { HardGame.new(hard_game).categories }

          it "should select two categories from double jeopardy" do
            expect(subject).to eql(clean_hard_game)
          end
        end
      end
    end
  end
end
