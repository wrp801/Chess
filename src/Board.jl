include("Pieces.jl")

########################################
#          Data type definitions                       
########################################

abstract type ChessBoard end

mutable struct ChessSquare <: ChessBoard
	is_empty::Bool
	piece::Union{Nothing,ChessPiece}
	color::Char
end

mutable struct Board  <: ChessBoard
	board::Array{ChessPiece}
	move::UInt16
end

function Board()
	board = Array{ChessPiece}(undef,8,8);
	move = 0;
	return Board(board,move)
end


########################################
#          Functions for board                       
########################################

function is_empty(board_square::ChessPiece)::Bool
	return isa(board_square,Empty)
end


function print_board(board::Board,view::Char = 'w')
	"""
	Prints the chess board in a readable format. 
	Args:
		board: The chess board to print
		view: Whether to view the board from white's (w) or black's (b) perspective
		
	"""
	## if the view is from the white perspective
	if view == 'w'
		rows = reverse(collect(1:8))
		cols = collect(1:8)
	end
	## if the view is from the black perspective 
	if view == 'b'
		rows = collect(1:8)
		cols = reverse(collect(1:8)) ## need to reverse columns for inverted view

	end
	for i in rows
		print(i,"  |",'\t')
		for j in cols
			print(board.board[i,j].label)
			print("\t")
		end
		println("")
	end
	println("------------------------------------------------------------------")
	for k in 1:8
		if k == 1
			print('\t',map_column(k),'\t')
		else
			print(map_column(k),'\t')
		end
	end
	println("")
end


#######################################
#      Populate Board with Pieces                       
#######################################
function initialize!(board::Board)
	rows = collect(1:8)
	for row in rows
		if row == 8
		## populate the black back rank
			board.board[row,1]= Rook('b',1)
			board.board[row,2]= Knight('b',2)
			board.board[row,3] = Bishop('b',3)
			board.board[row,4] = Queen('b',4)
			board.board[row,5] = King('b',5)
			board.board[row,6] = Bishop('b',6)
			board.board[row,7] = Knight('b',7)
			board.board[row,8] = Rook('b',8)
		elseif row == 7
		## populate the black pawns
			for col in 1:8
				board.board[row,col] = Pawn('b',col)
			end
		elseif row < 7 && row > 2
		## populate the empty spots
			for col in 1:8
				board.board[row,col] = Empty(row,col)
			end

		elseif row == 2
		## populate the white pawns
			for col in 1:8
				board.board[row,col] = Pawn('w',col)	
			end

		elseif row == 1
		## populate the white back rank
			board.board[row,1] = Rook('w',1)
			board.board[row,2] = Knight('w',2)
			board.board[row,3] = Bishop('w',3)
			board.board[row,4] = Queen('w',4)
			board.board[row,5] = King('w',5)
			board.board[row,6] = Bishop('w',6)
			board.board[row,7] = Knight('w',7)
			board.board[row,8] = Rook('w',8)
		end
	end
end

########################################
#           Helper functions                       
########################################
"""
Checks to see if a given tile on the chess board is occupied or not. If empty, true, otherwise false.
Params:
	index::Int : an index of the board, from 1-64 
	board::Board : a board struct defined in Board.jl

Return Type: Bool
"""
function isfree(index::Int,board::Board)
	str = INDEX_TO_TILE[index]
	tile = Tile(str)
	pos = tile.square
	index = TILE_TO_INDEX[pos]
	board_tile = board.board[index]
	return isa(board_tile,Empty)
end

"""
Checks to see if a given tile on the chess board is occupied or not. If empty, true, otherwise false.
Params:
	index::Tuple{Int,Int} : an index of the board in (row,column) format
	board::Board : a board struct defined in Board.jl

Return Type: Bool
"""
function isfree(index::Tuple{Int,Int},board::Board)
	single_index = PAIR_TO_INDEX[index]
	str = INDEX_TO_TILE[single_index]
	tile = Tile(str)
	pos = tile.square
	index = TILE_TO_INDEX[pos]
	board_tile = board.board[single_index]
	return isa(board_tile,Empty)
end
"""
Returns a the piece from the board given an index location
"""
function getpiece(index::Int,board::Board)::ChessPiece
	str = INDEX_TO_TILE[index]
	tile = Tile(str)
	pos = tile.square
	index = TILE_TO_INDEX[pos]
	board_tile = board.board[index]
	return board_tile
end

"""
Given a string (like e5), will return the associated chess piece at that index

"""
function getpiece(tile::Union{Tile,String},board::Board)::ChessPiece
	if isa(tile,Tile)
		index = TILE_TO_INDEX[tile.square]
	else
		index = TILE_TO_INDEX[tile]
	end
	return board.board[index]
end

"""
Returns the index of a piece in terms of (row,column) format
Params:
	piece::Union{Pawn,Knight,Bishop,Rook,Queen,King}: Chess piece
	board::Board: The chess board

Return Type: Union{Tuple{Int,Int},Nothing}: Returns a tuple of ints or nothing

"""
function getindex(piece::Union{Pawn,Knight,Bishop,Rook,Queen,King},board::ChessBoard)::Union{Tuple{Int,Int},Nothing}
	for row in 1:8
		for col in 1:8
			res = board.board[row,col]
			if res == piece
				return (row,col)
			end
		end
	end
	return nothing
end

"""
Returns true if piece on the tile is the opposite color of the piece provided
"""
function isopposite(piece::Union{Pawn,Knight,Bishop,Rook,Queen,King},board::ChessBoard,index::Int)
	other_piece = getpiece(index,board)
	if isa(other_piece,Empty)
		return true
	else
		return piece.color != other_piece.color
	end
end


########################################
#          Chess Board with GUI                       
########################################

# c = @GtkCanvas()
# win = GtkWindow(c, "Canvas")

# function rect!(ctx,x,y,w,h,col)
#     rectangle(ctx, x, y, w, h)
#     set_source_rgb(ctx, col...)
#     fill(ctx)
# end

# @guarded draw(c) do widget
#     ctx = getgc(c)
#     h,w = height(c), width(c)
    
#     N=8
#     for (i,x) in enumerate(linspace(0,w,N)), (j,y) in enumerate(linspace(0,h,N))
#         rect!(ctx,x,y,w/N,h/N, mod(i+j,2)==0 ? (0.1,0.1,0.1) : (1.0,1.0,1.0)  )
#     end
# end
# show(c)



