require 'pry'

module ConnectFour
    class Board
        attr_reader :slots
        
        def initialize(slot=nil)
            @slots = Array.new(Array.new(6) { Array.new(7) { slot ? slot : Slot.new } })
        end

        def rows
            @slots
        end

        def columns(columns=[])
            (0..6).each { |n| columns << get_column(n) }
            columns
        end

        def get_column(n, slots=[])
            @slots.each do |row|
                slots << row[n]
            end

            slots
        end

        def diagonals
            diagonals = []

            rows.each_with_index do |row, i|
                row.each_with_index do |slot, j|
                    break if i > 2

                    if j <= 3
                        diagonal = []
                        diagonal << rows[i][j]
                        (1..3).each { |n| diagonal << rows[i + n][j + n] }
                        
                        diagonals << diagonal
                    end

                    if j >= 3
                        diagonal = []
                        diagonal << rows[i][j]
                        (1..3).each { |n| diagonal << rows[i + n][j - n] }
                      
                        diagonals << diagonal
                    end
                end
            end


            diagonals
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
            [rows, columns, diagonals].each do |direction|
                direction.each do |line|
                    return true if has_four_in_a_row?(line)
                end
            end
            

            false
        end

        def stalemate?
            @slots.flatten.all? { |slot| slot.color } && !winner? ? true : false
        end

        def show
            board_string = ""

            @slots.each do |row|
                row.each_with_index do |slot, index|
                    if slot.color == "yellow"
                        board_string << " Y "
                    elsif slot.color == "red"
                        board_string << " R "
                    else
                        board_string << " # "
                    end

                    board_string << "\n" if index == 6
                end
            end

            print board_string
            board_string
        end


        private

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
        attr_accessor :name, :color

        def initialize(name="player", color="red")
            @name = name
            @color = color
        end
    end

    class Game
        attr_reader :board, :player_one, :player_two

        def initialize(board=Board.new, player_one=Player.new, player_two=Player.new)
            @board = board
            @player_one = player_one
            @player_two = player_two
        end

        def start
            [@player_one, @player_two].each_with_index do |player, index|
                default_names = ["Player one", "Player two"]
                puts "#{default_names[index]}, please enter your name:"
                player.name = gets.chomp
                print "\n"
            end

            @player_two.color = "yellow"
            puts start_message

            play_round
        end

        def play_round
            [@player_one, @player_two].each do |player|
                
                @board.drop_piece(get_valid_column(player), player.color)

                print "\n"
                puts "Here's what the board looks like now:"
                @board.show
                print "\n"
            end

        end

       
        private

        def get_valid_column(player)
            puts "#{player.name}, please enter a column to drop a piece in (0 - 6):"
            column_number = gets.chomp

            while !valid_column?(column_number)
                puts "That column is either full or does not exist. Please choose a different column (0 - 6):"
                column_number = gets.chomp
            end

            column_number.to_i
        end

        def valid_column?(number)
            !number.match(/^[0-6]$/) || column_full?(number.to_i) || !column_exists?(number.to_i) ? false : true
        end

        def column_full?(n)
            @board.get_column(n).all? { |slot| slot.color } ? true : false
        end

        def column_exists?(n)
            n >= 0 && n <=6 ? true : false
        end

        def start_message
            "#{@player_one.name} will be #{@player_one.color} and #{@player_two.name} will be #{@player_two.color}.\n\n"
        end
    end
end