using ..Globals
########################################
#           Helper functions                       
########################################
"""
Returns true if the chess square is empty
"""
function isempty(board_square::ChessPiece)::Bool
	return isa(board_square,Empty)
end

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
	if i2 < 1 || i1 > 8
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

"""
Checks to see if a queenside castle can be performed
"""
function can_castle_queenside(piece::King,board::Board)::Bool
    if !piece.is_first_move
        return false
    end
    index = piece.index
    for i in reverse(1:3)
        new_index = index - (8*i)
        new_piece = getpiece(new_index, board)
        if !isa(new_piece,Empty)
            return false
        end
    end
    rook = getpiece(index - 32)
    if !isa(rook,Rook) || !rook.is_first_move
        return false
    end
    return true
end


function attackingtiles(piece::Pawn,board::Board)::Vector{Int}
    ## TODO: need to account for en passant 
    
    ## get the possible attacking indices from the tile
    tiles = Vector{Int}()
    if piece.color == 'w'
        attack_indices = (-7,+9)
    elseif piece.color == 'b'
        attack_indices = (-9,+7)
    end
    
    for aindex in attack_indices
        new_index = piece.index + aindex
        if new_index < 65 && new_index > 0 && !isnothing(new_index)
            append!(tiles,new_index)
        end
    end
    return tiles
end

