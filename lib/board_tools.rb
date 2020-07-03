module BoardTools
    def set_stalemate(board)
        board.slots.each_with_index do |row, index|
            if index.even?
                board.slots[index] = [yellow_slot, yellow_slot, yellow_slot, red_slot, red_slot, red_slot, yellow_slot]
            else
                board.slots[index] = [red_slot, red_slot, red_slot, yellow_slot, yellow_slot, yellow_slot, red_slot]
            end
        end
    end

    def set_horizontal_win(board)
        (0..3).each { |n| board.slots[5][n] = red_slot }
    end

    def set_vertical_win(board)
        board.slots[0..3].map! { |row| row[0] = red_slot }
    end

    def set_diagonal_win(board)
        (0..3).each { |n| board.slots[n][n] = red_slot }
    end
end