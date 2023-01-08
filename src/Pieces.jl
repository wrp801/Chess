using ..Globals
abstract type ChessPiece end
########################################
#            Helpers                       
########################################

function map_column(column::Int)::Char
	if column > 8 | column < 1
		error("Column needs to be between 1 and 8")
	end
	if column == 1
		letter = 'a'
	elseif column == 2
		letter = 'b'
	elseif column == 3
		letter = 'c'
	elseif column == 4 
		letter = 'd'
	elseif column == 5
		letter = 'e'
	elseif column == 6 
		letter = 'f'
	elseif column == 7 
		letter = 'g'
	elseif column == 8
		letter = 'h'
	end
	return letter
end

########################################
#          Chess Piece Types                       
########################################

mutable struct Empty <: ChessPiece
	index::Int
	label::String 
end

mutable struct Pawn <: ChessPiece
	index::Int
	color::Char ## w for white and b for black
	is_first_move::Bool
	points::Int
	label::Char
	# location::Tuple{Int,Int}
end

mutable struct Knight <: ChessPiece 
	index::Int
	color::Char
	points::Int
	label::Char
	# location::Tuple{Int,Int}
end

mutable struct Bishop <: ChessPiece
	index::Int
	color::Char
	points::Int
	label::Char
	# location::Tuple{Int,Int}
end

mutable struct Rook <: ChessPiece
	index::Int
	color::Char
	is_first_move::Bool
	points::Int
	label::Char
	# location::Tuple{Int,Int}
end

mutable struct Queen <: ChessPiece
	index::Int
	color::Char
	points::Int
	label::Char
	# location::Tuple{Int,Int}
end

mutable struct King <: ChessPiece
	index::Int
	color::Char
	is_first_move::Bool
	label::Char
	# location::Tuple{Int,Int}
end

mutable struct Tile
	square::String
end

function Tile(piece::Union{Pawn,Knight,Bishop,Rook,Queen,King})::Tile
	return get_tile(piece.index)
	# pos = unpack_position(piece)
	# return Tile(pos)
end

"""
Parses the position of a chess piece and returns a string to be passed to a Tile struct 
"""
function unpack_position(piece::Union{Pawn,Knight,Bishop,Rook,Queen,King})
	letter = piece.position[1]
	position = piece.position[2]
	return string(letter,position)
end



########################################
#         Constructors for Pieces                       
########################################

function Knight(color::Char,column::Int,index::Int)
	## map the letter to the column index 
	letter = map_column(column)
	pts = 3
	if color == 'b'
		pos = (letter,8)
		label = 'n'
		return Knight(index,color,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'N'
		return Knight(index,color,pts,label)		
	end
end

function Knight(color::Char,column::Int,pair::Tuple{Int,Int})
	## map the letter to the column index 
	index = get_single_index(pair)
	letter = map_column(column)
	pts = 3
	if color == 'b'
		pos = (letter,8)
		label = 'n'
		return Knight(index,color,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'N'
		return Knight(index,color,pts,label)		
	end
end


function Bishop(color::Char,column::Int,index::Int)
	letter = map_column(column)
	pts = 3

	if color == 'b'
		pos = (letter,8)
		label = 'b'
		return Bishop(index,color,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'B'
		return Bishop(index,color,pts,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end
end

function Bishop(color::Char,column::Int,pair::Tuple{Int,Int})
	index = get_single_index(pair)
	letter = map_column(column)
	pts = 3

	if color == 'b'
		pos = (letter,8)
		label = 'b'
		return Bishop(index,color,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'B'
		return Bishop(index,color,pts,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end
end

function Rook(color::Char, column::Int, index::Int)
	letter = map_column(column)
	pts = 5

	if color == 'b'
		pos = (letter,8)
		label = 'r'
		return Rook(index,color,true,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'R'
		return Rook(index,color,true,pts,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end

end

function Rook(color::Char, column::Int, pair::Tuple{Int,Int})
	index = get_single_index(pair)
	letter = map_column(column)
	pts = 5

	if color == 'b'
		pos = (letter,8)
		label = 'r'
		return Rook(index,color,true,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'R'
		return Rook(index,color,true,pts,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end

end

function Queen(color::Char,column::Int,index::Int)
	letter = map_column(column)
	pts = 9

	if color == 'b'
		pos = (letter,8)
		label = 'q'
		return Queen(index,color,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'Q'
		return Queen(index,color,pts,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end
end

function Queen(color::Char, column::Int, pair::Tuple{Int,Int})
	index = get_single_index(pair)
	letter = map_column(column)
	pts = 9

	if color == 'b'
		pos = (letter,8)
		label = 'q'
		return Queen(index,color,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'Q'
		return Queen(index,color,pts,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end

end

function Pawn(color::Char,column::Int,index::Int)
	letter = map_column(column)
	pts = 1
	if color == 'b'
		pos = (letter,7)
		label = 'p'
	return Pawn(index,color,true,pts,label)
	elseif color == 'w'
		pos = (letter,2)
		label = 'P'
		return Pawn(index,color,true,pts,label)
	else 
		println("No color or invalid color entered; please enter either b for black or w for white")
	end
end

function Pawn(color::Char, column::Int, pair::Tuple{Int,Int})
	index = get_single_index(pair)
	letter = map_column(column)
	pts = 1
	if color == 'b'
		pos = (letter,7)
		label = 'p'
	return Pawn(index,color,true,pts,label)
	elseif color == 'w'
		pos = (letter,2)
		label = 'P'
		return Pawn(index,color,true,pts,label)
	else 
		println("No color or invalid color entered; please enter either b for black or w for white")
	end
end

function King(color::Char,column::Int,index::Int)
	letter = map_column(column)

	if color == 'b'
		pos = (letter,8)
		label = 'k'
		return King(index,color,true,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'K'
		return King(index,color,true,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end
end

function King(color::Char, column::Int, pair::Tuple{Int,Int})
	index = get_single_index(pair)
	letter = map_column(column)

	if color == 'b'
		pos = (letter,8)
		label = 'k'
		return King(index,color,true,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'K'
		return King(index,color,true,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end
end

function Empty(row::Int,column::Int)
	letter = map_column(column)
	pos = (letter,row)
	index = get_single_index((row,column))
	label = "*"
	return Empty(index,label)
end

function Empty(index::Int)
	label = "*"
	# tile = Tile(INDEX_TO_TILE[index])
	# letter = tile.square[1]
	# num = tile.square[2]
	# pos = (letter,num)
	return Empty(index,label)

end

function Empty(pair::Tuple{Int,Int})
	index = get_single_index(pair)
	label = "*"
	return Empty(index,label)
end


"""
Function to get the tile of the board. Takes a single index (1-64)
Params:
	index::Int - the single index (1-64) of the chess piece
"""
function get_tile(index::Int)
	return Tile(INDEX_TO_TILE[index])
end

"""
Function to get the tile of the board given a [row,index] pair.
Params:
	pair::Tuple{Int,Int} - the [row,index] pair of the chess piece
"""
function get_tile(pair::Tuple{Int,Int})
	single_index = PAIR_TO_INDEX[pair]
	return Tile(INDEX_TO_TILE[single_index])

end

"""
Function to get the tile of the board given a chess piece.
Params:
	piece::ChessPiece - the chess piece desired 
"""
function get_tile(piece::ChessPiece)
	return Tile(INDEX_TO_TILE[piece.index])
end

"""
Returns the [row,index] pair of the position given a single index number (1-64)
Params:
	index::Int - the single index (1-64) of the chess piece
"""
function getpair(index::Int)
	return INDEX_TO_PAIR[index]
end

"""
Returns the [row,index] pair of the position given the tile
Params:
	tile::Tile - the tile of the chess piece
"""
function getpair(tile::Tile)
	index = TILE_TO_INDEX[tile.square]
	return INDEX_TO_PAIR[index]
end


"""
Returns the [row,index] pair of the position given the ChessPiece
Params:
	piece::ChessPiece - The ChessPiece
"""
function getpair(piece::ChessPiece)
	return INDEX_TO_PAIR[piece.index]
end

"""
Returns the single index of the position given the [row,index] pair
Params:
	pair::Tuple{Int,Int} - the [row,index] pair of the chess piece
"""
function get_single_index(pair::Tuple{Int,Int})
	return PAIR_TO_INDEX[pair]
end

"""
Returns the single index of the position given the tile
Params:
	tile::Tile - the tile of the chess piece
"""
function get_single_index(tile::Tile)
	return TILE_TO_INDEX[tile.square]
end
