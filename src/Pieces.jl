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
	Position::Tuple{Char,Int}
	label::String 
end

mutable struct Pawn <: ChessPiece
	Position::Tuple{Char,Int}
	color::Char ## w for white and b for black
	is_first_move::Bool
	points::Int
	label::Char
end

mutable struct Knight <: ChessPiece 
	Position::Tuple{Char,Int}
	color::Char
	points::Int
	label::Char
end

mutable struct Bishop <: ChessPiece
	Position::Tuple{Char,Int}
	color::Char
	points::Int
	label::Char
end

mutable struct Rook <: ChessPiece
	Position::Tuple{Char,Int}
	color::Char
	is_first_move::Bool
	points::Int
	label::Char
end

mutable struct Queen <: ChessPiece
	Position::Tuple{Char,Int}
	color::Char
	points::Int
	label::Char
end

mutable struct King <: ChessPiece
	Position::Tuple{Char,Int}
	color::Char
	is_first_move::Bool
	label::Char
end

mutable struct Tile
	square::String
end

function Tile(piece::Union{Pawn,Knight,Bishop,Rook,Queen,King})::Tile
	pos = unpack_position(piece)
	return Tile(pos)
end

"""
Parses the position of a chess piece and returns a string to be passed to a Tile struct 
"""
function unpack_position(piece::Union{Pawn,Knight,Bishop,Rook,Queen,King})
	letter = piece.Position[1]
	position = piece.Position[2]
	return string(letter,position)
end



########################################
#         Constructors for Pieces                       
########################################

function Knight(color::Char,column::Int)
	## map the letter to the column index 
	letter = map_column(column)
	pts = 3
	if color == 'b'
		pos = (letter,8)
		label = 'n'
		return Knight(pos,color,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'N'
		return Knight(pos,color,pts,label)		
	end
end


function Bishop(color::Char,column::Int)
	letter = map_column(column)
	pts = 3

	if color == 'b'
		pos = (letter,8)
		label = 'b'
		return Bishop(pos,color,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'B'
		return Bishop(pos,color,pts,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end
end

function Rook(color::Char,column::Int)
	letter = map_column(column)
	pts = 5

	if color == 'b'
		pos = (letter,8)
		label = 'r'
		return Rook(pos,color,true,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'R'
		return Rook(pos,color,true,pts,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end

end

function Queen(color::Char,column::Int)
	letter = map_column(column)
	pts = 9

	if color == 'b'
		pos = (letter,8)
		label = 'q'
		return Queen(pos,color,pts,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'Q'
		return Queen(pos,color,pts,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end
end

function Pawn(color::Char,column::Int)
	letter = map_column(column)
	pts = 1
	if color == 'b'
		pos = (letter,7)
		label = 'p'
	return Pawn(pos,color,true,pts,label)
	elseif color == 'w'
		pos = (letter,2)
		label = 'P'
		return Pawn(pos,color,true,pts,label)
	else 
		println("No color or invalid color entered; please enter either b for black or w for white")
	end
end

function King(color::Char,column::Int)
	letter = map_column(column)

	if color == 'b'
		pos = (letter,8)
		label = 'k'
		return King(pos,color,true,label)
	elseif color == 'w'
		pos = (letter,1)
		label = 'K'
		return King(pos,color,true,label)
	else
		println("No color or invalid color entered; please enter either b for black or w for white")
	end

end

function Empty(row::Int,column::Int)
	letter = map_column(column)
	pos = (letter,row)
	label = "*"
	return Empty(pos,label)
end

function Empty(index::Int)
	label = "*"
	tile = Tile(INDEX_TO_TILE[index])
	letter = tile.square[1]
	num = tile.square[2]
	pos = (letter,num)
	return Empty(pos,label)

end

