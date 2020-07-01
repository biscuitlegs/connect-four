require_relative 'lib/connect_four'
include ConnectFour

b = Board.new
p b.get_diagonals
#p b.winner?