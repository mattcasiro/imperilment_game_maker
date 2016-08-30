require 'game_builder/scraper'

module GameBuilder
  
  describe JArchiveScraper do
    BASE_PATH = 'spec/game_builder/fixtures/'

    let(:scraper) { JArchiveScraper.new }

    # Test basic functionality on the oldest game
    context "Episode 0001" do
      subject { scraper.new_game!(BASE_PATH + 'show_1_id_173_S1E1.html') }

      it("has three rounds") { expect(subject.rounds.count).to eql(3) }
      
      context "the first two rounds" do
        it "each have six categories" do
          expect(subject.rounds[0].categories.count).to eql(6)
          expect(subject.rounds[1].categories.count).to eql(6)
        end

        context "each category" do
          it "has five clues with valid values" do
            subject.rounds.each_with_index do |r, i|
              break if i > 1    # ignore final jeopardy round

              r.categories.each do |category|
                expect(category.clues.count).to eql(5)

                category.clues.each do |clue|
                  if clue.question.nil? || clue.answer.nil?
                    expect(clue.value).to eql(nil)
                  else
                    expect(clue.value).to be > 0
                  end
                end
              end
            end
          end
        end
      end

      context "the final round" do
        it("has one category") { expect(subject.rounds.last.categories.count).to eql(1) }

        context "the category" do
          it("has one clue") { expect(subject.rounds.last.categories[0].clues.count).to eql(1) }
        end
      end

      context "an assortment of categories" do
        it "are correctly named" do
          expect(subject.rounds[0].categories[0].name).to eql("LAKES & RIVERS")
          expect(subject.rounds[0].categories[3].name).to eql("FOREIGN CUISINE")
          expect(subject.rounds[1].categories[2].name).to eql("NATIONAL LANDMARKS")
          expect(subject.rounds[1].categories[5].name).to eql("4-LETTER WORDS")
          expect(subject.rounds[2].categories[0].name).to eql("HOLIDAYS")
        end
      end

      context "an assortment of clues" do
        it "provide the correct output" do
          q_and_a_hash = Hash[
            (0..1).map do |i|
              (0..5).map do |j|
                [ "R#{i}-CA#{j}-CL#{j%5}", [subject.rounds[i].categories[j].clues[j%5].question, subject.rounds[i].categories[j].clues[j%5].answer] ]
              end
            end.flatten(1)
          ]
          q_and_a_hash['R2-CA0-CL0'] = [subject.rounds[2].categories[0].clues[0].question, subject.rounds[2].categories[0].clues[0].answer]
          expected = {
            "R0-CA0-CL0"=>["the Jordan", "River mentioned most often in the Bible"],
            "R0-CA1-CL1"=>["the rickshaw", "In 1869 an American minister created this \"oriental\" transportation"],
            "R0-CA2-CL2"=>["a weasel", "When husbands \"pop\" for an ermine coat, they\\'re actually buying this fur"],
            "R0-CA3-CL3"=>["ChÃ¢teaubriand", "French for a toothsome cut of beef served to a twosome"],
            "R0-CA4-CL4"=>["Colonel Chuck Yeager", "Sam Shepard played this barrier breaker in \"The Right Stuff\""],
            "R0-CA5-CL0"=>[nil, nil],
            "R1-CA0-CL0"=>["the walls", "When \"Joshua Fit The Battle Of Jericho\", these took a tumble"],
            "R1-CA1-CL1"=>["Eve Arden", "She was \"Our Miss Brooks\""],
            "R1-CA2-CL2"=>["Plymouth Rock", "The cornerstone of Massachusetts, it bears the date 1620"],
            "R1-CA3-CL3"=>[nil, nil],
            "R1-CA4-CL4"=>["John Wilkes Booth", "After the deed, he leaped to the stage shouting \"Sic semper tyrannis\""],
            "R1-CA5-CL0"=>["shot", "Pulled the trigger or what\\'s in a jigger"],
            "R2-CA0-CL0"=>["Martin Luther King Day", "The third Monday of January starting in 1986"]
          }
          expect(q_and_a_hash).to eql(expected)
        end
      end
    end

    # Test basic functionality on the newest game
    context "Episode 7351" do
      subject { scraper.new_game!(BASE_PATH + 'show_7351_id_5366_S32.html') }

      it("has three rounds") { expect(subject.rounds.count).to eql(3) }

      context "the first two rounds" do
        it "each have six categories" do
          expect(subject.rounds[0].categories.count).to eql(6)
          expect(subject.rounds[1].categories.count).to eql(6)
        end

        context "each category" do
          it "has five clues" do
            subject.rounds.each_with_index do |r, i|
              break if i > 1
              r.categories.each do |cat|
                expect(cat.clues.count).to eql(5)
              end
            end
          end
        end
      end

      context "the final round" do
        it("has one category") { expect(subject.rounds.last.categories.count).to eql(1) }

        context "the category" do
          it("has one clue") { expect(subject.rounds.last.categories[0].clues.count).to eql(1) }
        end
      end

      context "an assortment of categories" do
        it "are correctly named" do
          expect(subject.rounds[0].categories[1].name).to eql("7-LETTER WORDS")
          expect(subject.rounds[0].categories[4].name).to eql("\"M\"PLACEMENT")
          expect(subject.rounds[1].categories[0].name).to eql("ANATOMICALLY TITLED LIT")
          expect(subject.rounds[1].categories[3].name).to eql("HOLY MOSES!")
          expect(subject.rounds[2].categories[0].name).to eql("U.S. MONUMENTS")
        end
      end

      context "an assortment of clues" do
        it "provide the correct output" do
          q_and_a_hash = Hash[
            (0..1).map do |i|
              (0..5).map do |j|
                ["R#{i}-CA#{j}-CL#{j%5}", [subject.rounds[i].categories[j].clues[j%5].question, subject.rounds[i].categories[j].clues[j%5].answer] ]
              end
            end.flatten(1)
          ]
          q_and_a_hash['R2-CA0-CL0'] = [subject.rounds[2].categories[0].clues[0].question, subject.rounds[2].categories[0].clues[0].answer]
          expected = {
            "R0-CA0-CL0"=>["Wrigley\\'s", "Doublemint gum"],
            "R0-CA1-CL1"=>["a widower", "Term for a man who has not remarried after his wife passed away"],
            "R0-CA2-CL2"=>["the duck-billed platypus", "The existence of <a href=\"http://www.j-archive.com/media/2016-07-25_J_08.jpg\" target=\"_blank\">this creature</a> has been cited as proof that God has a sense of humor"],
            "R0-CA3-CL3"=>["Coolidge", "He was Massachusetts\\' favorite son candidate for president in 1920 bu settled for vice president"],
            "R0-CA4-CL4"=>["Malaysia", "This country\\'s 2 main regions are separated by some 640 miles of the South China Sea"],
            "R0-CA5-CL0"=>["stop motion", "(<a href=\"http://www.j-archive.com/media/2016-07-25_J_30.wmv\">Sarah of the Clue Crew delivers the clue from Laika Animation Studios.</a>) Laika Animation brings to life its magical worlds through the masterful use of this two-word classic animation technique that sounds like two opposite things"],
            "R1-CA0-CL0"=>["Sherlock Holmes", "A London bank job is at the heart of \"The Red-Headed League\", the second short story with this detective"],
            "R1-CA1-CL1"=>[nil, nil],
            "R1-CA2-CL2"=>["West Virginia", "Children of this \"Mountain State\" voted to make the rhododendron the state flower & the legislature obliged"],
            "R1-CA3-CL3"=>["let my people go", "When Moses confronts the pharaoh, these 4 words follow \"Thus saith the Lord God of Israel\""],
            "R1-CA4-CL4"=>["protocol", "To transfer large computer files, it might be useful to use a special FTP, a \"file transfer\" this"],
            "R1-CA5-CL0"=>["smuggle", "Non-magical \"Harry Potter\" folk illegally import an \"S\" to make this word"],
            "R2-CA0-CL0"=>["the Lincoln Memorial", "Tuskegee Institute president Robert Moton couldn\\'t sit with the other speakers at its 1922 dedication"],
          }
          expect(q_and_a_hash).to eql(expected)
        end
      end
    end

    # Test game without a round 1
    context "A game without a round 1" do
      it "should throw a 'Missing Round' error" do
        expect{ scraper.new_game!(BASE_PATH + "show_366_id_4284.html") }.to raise_error(MissingRoundError)
      end
    end

    # Test game without a round 2
    context "A game without a round 2" do
      it "should throw a 'Missing Round' error" do
        expect{ scraper.new_game!(BASE_PATH + "show_317_id_4256.html") }.to raise_error(MissingRoundError)
      end
    end

    # Test game without a final round
    context "A game without a final round" do
      it "should throw a 'Missing Round' error" do
        expect{ scraper.new_game!(BASE_PATH + "show_672_id_5348.html") }.to raise_error(MissingRoundError)
      end
    end

    # Test invalid clues changed nil
    context "Clues with placeholder data (instead of being empty)" do
      let(:game_348) { scraper.new_game!(BASE_PATH + "show_348_id_4271.html") }
      let(:game_465) { scraper.new_game!(BASE_PATH + "show_465_id_4788.html") }

      it "should return nil if '= / ='" do
        expect(game_348.rounds[0].categories[0].clues[0].question).to eql(nil)
        expect(game_348.rounds[0].categories[0].clues[0].answer).to eql(nil)
      end

      it "should return nil if '? / ='" do
        expect(game_348.rounds[0].categories[4].clues[3].question).to eql(nil)
        expect(game_348.rounds[0].categories[4].clues[3].answer).to eql(nil)
      end

      it "should return nil if '... / ...'" do
        expect(game_465.rounds[0].categories[1].clues[0].question).to eql(nil)
        expect(game_465.rounds[0].categories[1].clues[0].answer).to eql(nil)
      end
    end

    # Test pages with poor visual formatting are still processed properly
    context "A game with inconsistent visual formating online" do
      subject { scraper.new_game!(BASE_PATH + "show_383_id_4279.html") }

      it("has three rounds") { expect(subject.rounds.count).to eql(3) }

      context "the first two rounds" do
        it "each have six categories" do
          expect(subject.rounds[0].categories.count).to eql(6)
          expect(subject.rounds[1].categories.count).to eql(6)
        end

        context "each category" do
          it "has five clues" do
            subject.rounds.each_with_index do |r, i|
              break if i > 1
              r.categories.each do |cat|
                expect(cat.clues.count).to eql(5)
              end
            end
          end
        end
      end

      context "the final round" do
        it("has one category") { expect(subject.rounds.last.categories.count).to eql(1) }

        context "the category" do
          it("has one clue") { expect(subject.rounds.last.categories[0].clues.count).to eql(1) }
        end
      end
    end

    # Test symbols and characters are parsed correctly
    context "A string with non-english language characters" do
      let(:game_4812) { scraper.new_game!(BASE_PATH + "show_4812_id_426.html") }
      let(:game_6474) { scraper.new_game!(BASE_PATH + "show_6474_id_4010.html") }

      it "displays accented characters as displayed on the source page" do
        expect(game_4812.rounds[1] .categories[4].clues[4].question).to include("Ã", "¡")
      end

      it "displays symbols correctly" do
        expect(game_4812.rounds[1] .categories[3].clues[4].answer).to include("&")
      end

      it "displays underscores correctly" do
        expect(game_6474.rounds[0].categories[1].clues[0].answer).to include("____")
      end
    end
  end
end
