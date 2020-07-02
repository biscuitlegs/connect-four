require_relative "../lib/connect_four"
include ConnectFour

describe Board do
    let(:slot) { double("slot") }
    let(:red_slot) { double("red slot") }
    let(:yellow_slot) { double("yellow slot") }
    let(:board) { Board.new(slot) }

    before do 
        allow(red_slot).to receive(:color).and_return("red")
        allow(yellow_slot).to receive(:color).and_return("yellow")
        allow(slot).to receive(:color).and_return(nil)
    end
    

    describe "#initialize" do

        it "creates the correct number of squares" do
            expect(board.slots.length).to eql(6)
            board.slots.each { |row| expect(row).to eql(Array.new(7) { slot }) }
        end
    end

    describe "#rows" do
        it "returns every row" do
            expect(board.rows).to eql(Array.new(Array.new(6) { Array.new(7) { slot } })) 
        end
    end

    describe "#columns" do
        it "returns every column" do
            expect(board.columns).to eql(Array.new(7) { Array.new(6) { slot } })
        end
    end

    describe "#diagonals" do
        it "returns every diagonal" do
            expect(board.diagonals).to eql(Array.new(24) { Array.new(4) { slot } })
        end
    end

    describe "#get_column" do

        it "returns the squares in a column" do
            column_slot = double("column_slot")
            board.slots.each { |row| row[0] = column_slot }

            expect(board.get_column(0)).to eql(Array.new(6) { column_slot })
        end
    end

    describe "#find_open_slot" do

        it "returns the first open slot in a column" do
            open_slot = double("open_slot")
            allow(open_slot).to receive(:color).and_return(nil)
            
            board.slots[4..5].each { |row| row[0] = red_slot }
            board.slots[3][0] = open_slot

            expect(board.find_open_slot(0)).to eql(open_slot)
        end
    end

    describe "#drop_piece" do
        let(:target_slot) { double("target slot") }

        before do
            allow(target_slot).to receive(:color).and_return(nil)
            allow(target_slot).to receive(:color=)
        end

        context "when a column is empty" do

            it "drops a piece to the bottom" do
                board.slots[5][0] = target_slot
        
                expect(board.drop_piece(0, "yellow")).to eql(target_slot)
            end
        end
        context "when pieces are already in the column" do

            it "drops a piece on top of the other pieces" do
                board.slots[4..5].each { |row| row[0] = red_slot }
                board.slots[3][0] = target_slot
                
                expect(board.drop_piece(0, "yellow")).to eql(target_slot)
            end
        end
    end

    describe "#winner?" do
        context "when there is a winner" do
            context "when there is a horizontal win" do
                it "returns true" do
                    (2..5).each { |n| board.slots[0][n] = red_slot }
                
                    expect(board.winner?).to eql(true)
                end
            end
            context "when there is a vertical win" do
                it "returns true" do
                    board.slots[0..3].map! { |row| row[0] = red_slot }
                    
                    expect(board.winner?).to eql(true)
                end
            end
            context "when there is a diagonal win" do
                it "returns true" do
                    (0..3).each { |n| board.slots[n][n] = red_slot }
                    
                    expect(board.winner?).to eql(true)
                end
            end
        end
        context "when there is no winner" do
            it "returns false" do
                expect(board.winner?).to eql(false)
            end
        end
    end

    describe "#stalemate?" do
        context "when there is a stalemate" do
            it "returns true" do
                board.slots.each_with_index do |row, index|
                    if index.even?
                        board.slots[index] = [yellow_slot, yellow_slot, yellow_slot, red_slot, red_slot, red_slot, yellow_slot]
                    else
                        board.slots[index] = [red_slot, red_slot, red_slot, yellow_slot, yellow_slot, yellow_slot, red_slot]
                    end
                end

                expect(board.stalemate?).to eql(true)
            end
        end
        context "when there is no stalemate" do
            it "returns false" do
                expect(board.stalemate?).to eql(false)
            end
        end
    end

    describe "#show" do
        before { allow(board).to receive(:print) }

        context "when the board is empty" do
            it "shows an empty board" do
                expect(board.show).to eql(
                    " #  #  #  #  #  #  # \n" +
                    " #  #  #  #  #  #  # \n" +
                    " #  #  #  #  #  #  # \n" +
                    " #  #  #  #  #  #  # \n" +
                    " #  #  #  #  #  #  # \n" +
                    " #  #  #  #  #  #  # \n"
                )
            end
        end

        context "when the board has pieces" do
            it "shows the pieces on the board" do
                board.slots[5][0] = red_slot
                board.slots[4][0] = yellow_slot

                expect(board.show).to eql(
                    " #  #  #  #  #  #  # \n" +
                    " #  #  #  #  #  #  # \n" +
                    " #  #  #  #  #  #  # \n" +
                    " #  #  #  #  #  #  # \n" +
                    " Y  #  #  #  #  #  # \n" +
                    " R  #  #  #  #  #  # \n"
                )
            end
        end
    end

end

describe Slot do
    describe "#initialize" do
        context "when no color is given" do
            let(:slot) { Slot.new }

            it "has no color" do
                expect(slot.color).to eql(nil)
            end
        end

        context "when a color is given" do
            let(:slot) { Slot.new("red") }

            it "has the given color" do
                expect(slot.color).to eql("red")
            end
        end
    end

    describe "#to_s" do
        let(:slot) { Slot.new("yellow") }
        
        it "returns the color of the slot" do
            expect(slot.to_s).to eql("yellow")
        end
    end
end

describe Player do
    let(:player) { Player.new }

    describe "#initialize" do
        context "when no name is given" do
            
            it "is named 'player' by default" do
                expect(player.name).to eql("player")
            end
        end

        context "when a name is given" do
            let(:player) { Player.new("Jeff") }

            it "has the given name" do
                expect(player.name).to eql("Jeff")
            end
        end

        context "when no color is given" do
            it "is red by default" do
                expect(player.color).to eql("red")
            end
        end

        context "when a color is given" do
            let(:player) { Player.new("Dave", "yellow") }
            it "is the given color" do
                expect(player.color).to eql("yellow")
            end
        end
        
    end
end

describe Game do
    let(:game) { Game.new }
    let(:player_one) { double("player one") }
    let(:player_two) { double("player two") }
    let(:board) { double("board") }

    before do
        allow(game).to receive(:puts)
        allow(game).to receive(:print)
        allow(player_one).to receive(:color).and_return("red")
        allow(player_two).to receive(:color).and_return("yellow")
        allow(player_one).to receive(:name).and_return("Dave")
        allow(player_two).to receive(:name).and_return("Jeff")
        [player_one, player_two].each do |player|
            allow(player).to receive(:name=)
            allow(player).to receive(:color=)
        end
    end

    describe "#initialize" do
        before do
        allow(board).to receive(:class).and_return(Board)
        allow(player_one).to receive(:class).and_return(Player)
        allow(player_two).to receive(:class).and_return(Player)
        end

        context "when no board or players are given" do
            
            it "uses default board and players" do
                expect(game.board).to be_a(Board)
                expect(game.player_one).to be_a(Player)
                expect(game.player_two).to be_a(Player)
            end
        end
        context "when a board or players are given" do
            let(:game) { Game.new(board, player_one, player_two) }

            it "uses the given board and players" do
                expect(game.board).to eql(board)
                expect(game.player_one).to eql(player_one)
                expect(game.player_two).to eql(player_two)
            end
        end
    end

    describe "#start" do
        before do 
            allow(game).to receive(:gets).and_return("Dave", "Jeff", "0", "0")
            allow(game.board).to receive(:show)
        end
    
        it "gets the players' names" do
            game.start
            expect(player_one.name).to eql("Dave")
            expect(player_two.name).to eql("Jeff")
        end

        it "assigns the players' colors" do
            game.start
            expect(player_one.color).to eql("red")
            expect(player_two.color).to eql("yellow")
        end
        
        it "tells the players about the game" do
            expect(game).to receive(:start_message)
            game.start
        end

        it "lets each player play a round" do
            expect(game).to receive(:play_round)
            game.start
        end
    
    end

    describe "#play_round" do
        let(:board) { Board.new }
        let(:game) { Game.new(board, player_one, player_two) }
        before do 
            allow(game).to receive(:gets).and_return("0")
            allow(game.board).to receive(:show)
        end

        context "when the players select valid columns" do
            it "lets both players drop a piece" do
                game.play_round
        
                expect(game.board.slots[5][0].color).to eql("red")
                expect(game.board.slots[4][0].color).to eql("yellow")
            end
        end
        context "when a player selects an invalid column" do
            before { allow(game).to receive(:gets).and_return("11", "0") }
            
            it "asks for a different column" do
                game.play_round
        
                expect(game.board.slots[5][0].color).to eql("red")
                expect(game.board.slots[4][0].color).to eql("yellow")
            end
        end
    end

end