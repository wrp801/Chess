using Test
using StatsBase
include("../src/Board.jl")
include("../src/Moves.jl")

########################################
#   Set up variables to be used in the tests                       
########################################

board = Board()
initialize!(board)	

## white pawns
wp1 = getpiece("a2",board)
wp2 = getpiece("b2",board)
wp3 = getpiece("c2",board)
wp4 = getpiece("d2",board)
wp5 = getpiece("e2",board)
wp6 = getpiece("f2",board)
wp7 = getpiece("g2",board)
wp8 = getpiece("h2",board)

## black pawns
bp1 = getpiece("a7",board)
bp2 = getpiece("b7",board)
bp3 = getpiece("c7",board)
bp4 = getpiece("d7",board)
bp5 = getpiece("e7",board)
bp6 = getpiece("f7",board)
bp7 = getpiece("g7",board)
bp8 = getpiece("h7",board)

## white knights 
wk1 = getpiece("b1",board)
wk2 = getpiece("g1",board)

## black knights
bk1 = getpiece("b8",board)
bk2 = getpiece("g8",board)

## white bishops
wb1 = getpiece("c1",board)
wb2 = getpiece("f1",board)

## black bishops 
bb1 = getpiece("c8",board)
bb2 = getpiece("f8",board)

## white rooks 
wr1 = getpiece("a1",board)
wr2 = getpiece("h1",board)

## black rooks
br1 = getpiece("a8",board)
br2 = getpiece("h8",board)

## white queen
wq = getpiece("d1",board)

## black queen
bq = getpiece("d8",board)

## white king 
wk = getpiece("e1",board)

## black king
bk = getpiece("e8",board)

@testset "Board Initialization" begin 
	# board = Board()
	# initialize!(board)
	## color is white here 
	@test length(board.board) == 64
	@test typeof(board.board[1,1]) == Rook && board.board[1,1].color == 'w'
	@test typeof(board.board[1,2]) == Knight && board.board[1,2].color == 'w'
	@test typeof(board.board[1,3]) == Bishop && board.board[1,3].color == 'w'
	@test typeof(board.board[1,4]) == Queen && board.board[1,4].color == 'w'
	@test typeof(board.board[1,5]) == King && board.board[1,5].color == 'w'
	@test typeof(board.board[1,6]) == Bishop && board.board[1,6].color == 'w'
	@test typeof(board.board[1,7]) == Knight && board.board[1,7].color == 'w'
	@test typeof(board.board[1,8]) == Rook && board.board[1,8].color == 'w'
end


@testset "Pawn moves" begin
	# # board = Board()
	# # initialize!(board)	
	# ## check to see if the tile e2 is indeed a pawn with two available moves
	# e2 = getpiece("e2",board)
	# e2_moves = get_moves(e2,board)
	# @test typeof(e2) == Pawn && e2.color == 'w'
	# @test length(e2_moves) == 2
	# move!(e2_moves,e2,board,true)
	# @test typeof(getpiece("e2",board)) == Empty
	@test wp1.color == 'w'
	@test wp2.color == 'w'
	@test wp3.color == 'w'
	@test wp4.color == 'w'
	@test wp5.color == 'w'
	@test wp6.color == 'w'
	@test wp7.color == 'w'
	@test wp8.color == 'w'

	@test bp1.color == 'b'
	@test bp2.color == 'b'
	@test bp3.color == 'b'
	@test bp4.color == 'b'
	@test bp5.color == 'b'
	@test bp6.color == 'b'
	@test bp7.color == 'b'
	@test bp8.color == 'b'

	## select a random pawn and check that it has 2 moves available
	opts = [wp1,wp2,wp3,wp4,wp5,wp6,wp7,wp8,bp1,bp2,bp3,bp4,bp5,bp6,bp7,bp8]
	selected = sample(opts,1)[1]

	moves = get_moves(selected,board)
	@test length(moves) == 2

end

@testset "Knight Moves" begin
	# board = Board()
	# initialize!
	b1 = getpiece("b1",board)
	g1 = getpiece("g1",board)
	@test typeof(b1) == Knight && typeof(g1) == Knight
end

@testset "Find King" begin 
	b1 = getpiece("b1",board)
	k = find_king(b1,board)
	k_piece = getpiece(k,board)
	@test typeof(k_piece) == King && k_piece.color == 'w'
end