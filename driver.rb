require_relative 'lib/connect_four'
include ConnectFour

b = Board.new
p b.diagonals.length

#p b.winner?