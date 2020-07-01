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

        context "when column is empty" do

            it "drops a piece to the bottom" do
                board.slots[5][0] = target_slot
        
                expect(board.drop_piece(0, "yellow")).to eql(target_slot)
            end
        end
        context "when a piece is already in the column" do

            it "drops a piece on top of the other pieces" do
                board.slots[4..5].each { |row| row[0] = red_slot }
                board.slots[3][0] = target_slot
                
                expect(board.drop_piece(0, "yellow")).to eql(target_slot)
            end
        end
    end

    describe "#winner?" do
        context "when there is a winner" do
            context "when horizontal win" do
                it "returns true" do
                    (2..5).each { |n| board.slots[0][n] = red_slot }
                
                    expect(board.winner?).to eql(true)
                end
            end
            context "when vertical win" do
                it "returns true" do
                    board.slots[0..3].map! { |row| row[0] = red_slot }
                    
                    expect(board.winner?).to eql(true)
                end
            end
            context "when diagonal win" do
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
    describe "#initialize" do
        context "when no name is given" do
            let(:player) { Player.new }

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
    end
end

describe Game do
    describe "#initialize" do
        context "when no board or players are given" do
            let(:game) { Game.new }

            it "uses default board and players" do
                expect(game.board.class).to eql(Board)
                expect(game.player_one.class).to eql(Player)
                expect(game.player_two.class).to eql(Player)
            end
        end
        context "when a board or players are given" do
            let(:board) { Board.new }
            let(:player_one) { Player.new }
            let(:player_two) { Player.new }
            let(:game) { Game.new(board, player_one, player_two) }

            it "uses the given board and players" do
                expect(game.board).to eql(board)
                expect(game.player_one).to eql(player_one)
                expect(game.player_two).to eql(player_two)
            end
        end
    end
end