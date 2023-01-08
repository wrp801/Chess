using ..Globals


########################################
#         Set of pieces to track                       
########################################

########################################
#          Data type definitions                       
########################################
abstract type ChessBoard end
mutable struct ChessSquare <: ChessBoard
	isempty::Bool
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

mutable struct Fen
	placement::String ## where the pieces are on the board
	turn::String ## whether it is white or black who moves first
	castling::String ## the castling rights of white and black
	enpassant::String ## possible en passant squares
	halfmove::String ## number of moves each side has made
	fullmove::String ## number of completed turns (is incremented when black moves)
end

"""
Creates a Fen struct from a string
"""
function Fen(fen::String)
    splits = split(fen," ") ## this will separate the fen string into appropriate actions
    return Fen(splits[1],splits[2],splits[3],splits[4],splits[5],splits[6])
end


########################################
#          Functions for board                       
########################################
"""
Updates a board to the fen position provided
Params:
	fen::Fen - the Fen struct of the board position
	board::Board - the board to modify
"""
function readfen!(fen::Fen,board::Board)
    ## example fen for starting position is rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
    positions = fen.placement
    rows = split(positions,"/") ## this is where every 
	## populate every cell as empty
	for i in 1:8
		for j in 1:8
			board.board[i,j] = Empty(i,j)
		end
	end
	rid = 8 ## row number
	for row in rows
		cid = 1 ## column number
		if length(row) == 8 ## this is the easiest case to handle
			for char in row
				if isdigit(char)
					digit = parse(Int,char)
					cid+=digit
					continue
				else
					## black pieces
					if char == 'r'
						board.board[rid,cid] = Rook('b',cid,(rid,cid))
					elseif char == 'n'
						board.board[rid,cid] = Knight('b',cid,(rid,cid))
					elseif char == 'b'
						board.board[rid,cid] = Bishop('b',cid,(rid,cid))
					elseif char == 'k'
						board.board[rid,cid] = King('b',cid,(rid,cid))
					elseif char == 'q'
						board.board[rid,cid] = Queen('b',cid,(rid,cid))
					elseif char == 'p'
						board.board[rid,cid] = Pawn('b',cid,(rid,cid))
					## white pieces
					elseif char == 'R'
						board.board[rid,cid] = Rook('w',cid,(rid,cid))
					elseif char == 'N'
						board.board[rid,cid] = Knight('w',cid,(rid,cid))
					elseif char == 'B'
						board.board[rid,cid] = Bishop('w',cid,(rid,cid))
					elseif char == 'K'
						board.board[rid,cid] = King('w',cid,(rid,cid))
					elseif char == 'Q'
						board.board[rid,cid] = Queen('w',cid,(rid,cid))
					elseif char == 'P'
						board.board[rid,cid] = Pawn('w',cid,(rid,cid))
					end
				end
				cid+=1
			end
		else
			cid = 1
			for char in row
				if isdigit(char)
					digit = parse(Int,char)
					cid += digit
					continue
					# dig = parse(Int,char)
					# for i in 1:dig
					# 	board.board[rid,cid] = Empty(rid,cid)
					# 	cid+=1 
					# end
				else
					if char == 'r'
						board.board[rid,cid] = Rook('b',cid,(rid,cid))
					elseif char == 'n'
						board.board[rid,cid] = Knight('b',cid,(rid,cid))
					elseif char == 'b'
						board.board[rid,cid] = Bishop('b',cid,(rid,cid))
					elseif char == 'k'
						board.board[rid,cid] = King('b',cid,(rid,cid))
					elseif char == 'q'
						board.board[rid,cid] = Queen('b',cid,(rid,cid))
					elseif char == 'p'
						board.board[rid,cid] = Pawn('b',cid,(rid,cid))
					## white pieces
					elseif char == 'R'
						board.board[rid,cid] = Rook('w',cid,(rid,cid))
					elseif char == 'N'
						board.board[rid,cid] = Knight('w',cid,(rid,cid))
					elseif char == 'B'
						board.board[rid,cid] = Bishop('w',cid,(rid,cid))
					elseif char == 'K'
						board.board[rid,cid] = King('w',cid,(rid,cid))
					elseif char == 'Q'
						board.board[rid,cid] = Queen('w',cid,(rid,cid))
					elseif char == 'P'
						board.board[rid,cid] = Pawn('w',cid,(rid,cid))
					end
					cid +=1
				end
			end
        end
		rid-=1
    end
end

function isempty(board_square::ChessPiece)::Bool
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
			board.board[row,1]= Rook('b',1,(row,1))
			board.board[row,2]= Knight('b',2,(row,2))
			board.board[row,3] = Bishop('b',3,(row,3))
			board.board[row,4] = Queen('b',4,(row,4))
			board.board[row,5] = King('b',5,(row,5))
			board.board[row,6] = Bishop('b',6,(row,6))
			board.board[row,7] = Knight('b',7,(row,7))
			board.board[row,8] = Rook('b',8,(row,8))
		elseif row == 7
		## populate the black pawns
			for col in 1:8
				board.board[row,col] = Pawn('b',col,(row,col))
			end
		elseif row < 7 && row > 2
		## populate the empty spots
			for col in 1:8
				# board.board[row,col] = Empty(row,col)
				board.board[row,col] = Empty((row,col))
			end

		elseif row == 2
		## populate the white pawns
			for col in 1:8
				board.board[row,col] = Pawn('w',col,(row,col))	
			end

		elseif row == 1
		## populate the white back rank
			board.board[row,1] = Rook('w',1,(row,1))
			board.board[row,2] = Knight('w',2,(row,2))
			board.board[row,3] = Bishop('w',3,(row,3))
			board.board[row,4] = Queen('w',4,(row,4))
			board.board[row,5] = King('w',5,(row,5))
			board.board[row,6] = Bishop('w',6,(row,6))
			board.board[row,7] = Knight('w',7,(row,7))
			board.board[row,8] = Rook('w',8,(row,8))
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
Checks to see if a given tile on the chess board is occupied or not. If empty, true, otherwise false.
Params:
	tile: a tile struct (i.e a3)
	board: a board struct defined in Board.jl

Return Type: Bool

"""
function isfree(tile::Tile,board::Board)::Bool
	pos = tile.square
	index = TILE_TO_INDEX[pos]
	board_tile = board.board[index]
	return isa(board_tile,Empty)
end

"""
Checks to see whether a (row,column) tuple is a valid for a chess board.
"""
function isvalid(index::Tuple{Int,Int})::Bool
	i1 = index[1]
	i2 = index[2]
	if i1 < 1 || i2 > 8
		return false
	end
	if i2 < 1 || i2 > 8
		return false
	end
	return true
end

"""
Returns a the piece from the board given an index location
Params:
	index::Int : an index of the board between 1 and 64 inclusive
	board::Board : a board struct defined in Board.jl
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
Params:
	tile::Union{Tile,String} : either takes a tile struct or a string (like "e5")
	board::Board : a board struct defined in Board.jl

Return: ChessPiece - returns the piece
"""
function getpiece(tile::Union{Tile,String},board::Board)::ChessPiece
	if isa(tile,Tile)
		index = TILE_TO_INDEX[tile.square]
	else
		index = TILE_TO_INDEX[lowercase(tile)]
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
function Base.getindex(piece::Union{Pawn,Knight,Bishop,Rook,Queen,King},board::ChessBoard)::Union{Tuple{Int,Int},Nothing}
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
Params:
	piece:: Union{Pawn,Knight,Bishop,Rook,Queen,King : the chess piece
	board::Board - the chess board
Return : Bool
"""
function isopposite(piece::Union{Pawn,Knight,Bishop,Rook,Queen,King},board::ChessBoard,index::Int)::Bool
	other_piece = getpiece(index,board)
	if isa(other_piece,Empty)
		return true
	else
		return piece.color != other_piece.color
	end
end


"""
Returns the tile of the associated King
This is to be used to determine if the King is in check
Params:
	piece: Union{Pawn,Knight,Bishop,Rook,Queen,King} - the chess piece
	board::Board - the chess board
Return : Tile - returns the Tile where the King is located
"""
function find_king(piece::Union{Pawn,Knight,Bishop,Rook,Queen,King},board::Board)::Tile
	color = piece.color
	## find the king 
	for i in 1:64
		temp_piece = getpiece(i,board)
		if isa(temp_piece,King) && temp_piece.color == color
			return Tile(temp_piece)
		end
	end
end

"""
Returns the tile of the associated king of the same color provided as an argument to the function

Params: 
	color::Char - The color of the desired king, either 'w' or 'b'
	board::Board - the chess board
Return : Tile - returns the Tile where the King is located
"""
function find_king(color::Char,board::Board)::Tile
	for i in 1:65
		temp_piece = getpiece(i,board)
		if isa(temp_piece,King) && temp_piece.color == color
			return Tile(temp_piece)
		end
	end
end

"""
Checks to see whether the King is in check or not

Params:
	piece::King - the King
	board::Board - the chess board

Return : Bool - returns true if the King is in check and false otherwise
"""
function ischeck(piece::King,board::Board)::Bool
	## check for check on the diagonals
	index = getindex(piece,board)
	row = index[1]
	col = index[2]
	return false
end


"""
Checks to see if the king is in checkmate or not
"""
function ischeckmate(piece::King,board::Board)::Bool
	println("REPLACE ME")
end

"""
Checks to see if a kingside castle can be performed
"""
function can_castle_kingside(piece::King,board::Board)
	## check for rooks first
	if !piece.is_first_move
		return false
	end
	index = piece.index
	for i in 1:2
		new_index = index + (8*i)
		new_piece = getpiece(new_index,board)
		if !isa(new_piece,Empty)
			return false
		end
	end
	rook = getpiece(index+24,board)
	if !isa(rook,Rook) || !rook.is_first_move
		return false
	end
	return true
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
