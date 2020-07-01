require 'pry'

module ConnectFour
    class Board
        attr_reader :slots
        
        def initialize(slot=nil)
            @slots = Array.new(Array.new(6) { Array.new(7) { slot ? slot : Slot.new } })
        end

        def get_column(n, slots=[])
            @slots.each do |row|
                slots << row[n]
            end

            slots
        end

        def get_diagonals
            diagonals = []

            @slots.each_with_index do |row, i|
                slots.each_with_index do |slot, j|
                    break if i > 2

                    if j <= 3
                        diagonal = []
                        diagonal << slots[i][j]
                        (1..3).each { |n| diagonal << slots[i + n][j + n] }
                        
                        diagonals << diagonal
                    end

                    if j >= 3
                        diagonal = []
                        diagonal << slots[i][j]
                        (1..3).each { |n| diagonal << slots[i + n][j - n] }
                      
                        diagonals << diagonal
                    end
                    
                end
                
            end

            diagonals.select {|diagonal| diagonal.length == 4}
        end

        def find_open_slot(n)
            get_column(n).reverse.find { |slot| !slot.color }
        end

        def drop_piece(n, color)
            slot = find_open_slot(n)
            slot.color = color
            slot
        end

        def winner?
            @slots.each do |row|
                return true if has_four_in_a_row?(row)
            end

            (0..6).each do |n|
                column = get_column(n)
                return true if has_four_in_a_row?(column)
            end

            get_diagonals.each do |diagonal|
                return true if has_four_in_a_row?(diagonal)
            end


            false
        end

        def stalemate?
            @slots.flatten.all? { |slot| slot.color } && !winner? ? true : false
        end

        def has_four_in_a_row?(array, &block)
            array.each_with_index do |item, index|
                array.length == 4 ? four = array : four = array[index..index + 3]
                break if index > 3
                return true if four.all? { |slot| slot.color == "red" }
                return true if four.all? { |slot| slot.color == "yellow" }
            end

            false
        end
    end

    class Slot
        attr_accessor :color

        def initialize(color=nil)
            @color = color
        end

        def to_s
            @color
        end
    end

    class Player
        attr_reader :name

        def initialize(name="player")
            @name = name
        end
    end

    class Game
        attr_reader :board, :player_one, :player_two

        def initialize(board=Board.new, player_one=Player.new, player_two=Player.new)
            @board = board
            @player_one = player_one
            @player_two = player_two
        end
    end
end