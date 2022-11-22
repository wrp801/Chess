using ..Globals

## The thought process behind getting all the moves can be boiled down as follows:

# IF move does not result in check
#   THEN  legal_moves =  Capture moves ∪ Noncapture moves
########################################
#       Implement Move function                       
########################################

########################################
#          Utility functions                        
########################################

"""
Returns all the available diagonal moves. Desgined to be a helper function and is therfore piece agnostic
"""
function getdiagonalmoves(tile::Tile,board::Board)::Vector{Int}
	moves = Vector{Int}() ## the vecotr to be populated with valid diagonal moves
	pos = tile.square
	index = TILE_TO_INDEX[pos]
	double_index = INDEX_TO_PAIR[index]
	## check the up-right diagonal
	up_right_index = double_index
	piece = getpiece(index,board)
	while true
		new_upright = (up_right_index[1] + 1,up_right_index[2] + 1)
		if isvalid(new_upright) 
			new_single = PAIR_TO_INDEX[new_upright]
			if isopposite(piece,board,new_single) || isfree(new_single,board)
				append!(moves,new_single)
				up_right_index = new_upright
			else
				break
			end
		else
			break
		end
	end
	## check the up-left diagonal
	up_left_index = double_index
	while true
		new_upleft = (up_left_index[1] + 1,up_left_index[2] - 1)
		if isvalid(new_upleft)
			new_single = PAIR_TO_INDEX[new_upleft]
			if isopposite(piece,board,new_single) || isfree(new_single,board)
				append!(moves,new_single)
				up_left_index = new_upleft
			else
				break
			end
		else
			break
		end
	end
	## check the down-right diagonal
	down_right_index = double_index
	while true
		new_downright = (down_right_index[1] - 1,down_right_index[2] + 1)
		if isvalid(new_downright) 
			new_single = PAIR_TO_INDEX[new_downright]
			if isopposite(piece,board,new_single) || isfree(new_single,board)
				append!(moves,new_single)
				down_right_index = new_downright
			else 
				break
			end
		else
			break
		end
	end

	## check the down-left diagonal
	down_left_index = double_index
	while true
		new_downleft = (down_left_index[1] - 1,down_left_index[2] - 1)
		if isvalid(new_downleft) 
			new_single = PAIR_TO_INDEX[new_downleft]
			if isopposite(piece,board,new_single) || isfree(new_single,board)
				append!(moves,new_single)
				down_left_index = new_downleft
			else
				break
			end
		else
			break
		end
	end
	return moves
end

function get_rook_moves(tile::Tile,board::Board)::Vector{Int}
	moves = Vector{Int}() ## the vecotr to be populated with valid diagonal moves
	pos = tile.square
	index = TILE_TO_INDEX[pos]
	double_index = INDEX_TO_PAIR[index]
	## get the available vertical moves
	piece = getpiece(index,board)
	up_index = double_index
	while true
		new_up = (up_index[1]+1,up_index[2])
		if isvalid(new_up)
			new_single = PAIR_TO_INDEX[new_up]
			if isopposite(piece,board,new_single) || isfree(new_single,board)
				append!(moves,new_single)
				up_index = new_up
			else
				break
			end
		else 
			break
		end
	end

	## get the available down moves
	down_index = double_index
	while true
		new_down = (down_index[1]-1,down_index[2])
		if isvalid(new_down)
			new_single = PAIR_TO_INDEX[new_down]
			if isopposite(piece,board,new_single) || isfree(new_single,board)
				append!(moves,new_single)
				down_index = new_down
			else
				break
			end
		else
			break
		end
	end
	## get horizontal moves to the left
	left_index = double_index
	while true
		new_left = (left_index[1],left_index[2]-1)
		if isvalid(new_left)
			new_single = PAIR_TO_INDEX[new_left]
			if isopposite(piece,board,new_single) || isfree(new_single,board)
				append!(moves,new_single)
				left_index = new_left
			else
				break
			end
		else
			break
		end
	end
	## get the horizontal moves to the right
	right_index = double_index
	while true
		new_right = (right_index[1],right_index[2]+1)
		if isvalid(new_right)
			new_single = PAIR_TO_INDEX[new_right]
			if isopposite(piece,board,new_single) || isfree(new_single,board)
				append!(moves,new_single)
				right_index = new_right
			else
				break
			end
		else
			break
		end
	end
	return moves
end

########################################
#           Moves for Pieces                       
########################################
"""
Provides the list of all legal moves for a pawn
"""
function getmoves(pawn::Pawn,board::Board)

	## if it is the first move then the pawn can move 1 or two spaces forward
	# pawn.position 
	tile = Tile(pawn)
	current_index = TILE_TO_INDEX[tile.square]
	moves = Vector{Int}() ## empty vector to add moves to 
	if pawn.color == 'w'
		## capture logic
		diag_indices = (current_index -7, current_index + 8)
		for d in diag_indices
			spot = getpiece(d,board)
			if isa(spot,Empty) || spot.color == 'b' ## assure that the tile is not empty or occupied by a piece of the same color
				continue
			else
				append!(moves,d)
			end
		end

		if pawn.is_first_move
			## options are add two to the available moves
			## first check if the spot is open
			## forward one for white is -8, forward 2 is -16 
			# moves = (current_index + 1, current_index + 2)
			for i in 1:2
				append!(moves,current_index+i)
			end
		else
			## It is not the first move, so the pawn can only advance one spot or capture
			append!(moves,current_index+1)
			# moves = (current_index + 1)
		end
		for m in moves 
			if !isfree(m,board)
				moves = filter(x -> x != m,moves)
			end
		end
		tiles = map(x -> Tile(INDEX_TO_TILE[x]),moves)
		return tiles

	elseif pawn.color == 'b'
		diag_indices = (current_index +7, current_index - 8)
		for d in diag_indices
			spot = getpiece(d,board)
			if isa(spot,Empty) || spot.color == 'w' ## assure that the tile is not empty or occupied by a piece of the same color
				continue
			else
				append!(moves,d)
			end
		end


		if pawn.is_first_move
			for i in 1:2
				append!(moves,current_index - i)
			end
			# moves = (current_index - 1,current_index - 2)
		else
			append!(moves,current_index - 1)
			# moves = (current_index - 1)
		end
		for m in moves 
			if !isfree(m,board)
				moves = filter(x -> x != m,moves)
			end
		end
		tiles = map(x -> Tile(INDEX_TO_TILE[x]),moves) ## convert to tiles
		return tiles
	end
end

"""
Applies a move to the board for a pawn
"""
function move!(moves::Vector{Tile},pawn::Pawn,board::Board,random::Bool)
	# current_position = unpack_position(pawn) ## get the current tile of the piece
	current_position = Tile(pawn)
	if random
		random_index = rand(1:length(moves))
		move_to_make = moves[random_index]
		
	end
	old_index = TILE_TO_INDEX[current_position.square]
	new_index = TILE_TO_INDEX[move_to_make.square]
	board.board[new_index] = pawn
	board.board[old_index] = Empty(old_index) 
	updated_position_char = move_to_make.square[1]
	updated_position_num = parse(Int,move_to_make.square[2])
	pawn.position = (updated_position_char,updated_position_num)
	 
	
	pawn.is_first_move = false

	## else this needs to select the optimal move based on a heuristic function
	
end


"""
Provides the list of all legal moves for a knight
"""
function getmoves(knight::Knight,board::Board)
	## A Knight can move 8 spaces
	# Options are
	# 1. Index - 15
	# 2. Index - 6
	# 3. Index + 10 
	# 4. Index + 17
	# 5. Index + 15
	# 6. Index + 6
	# 7. Index -10
	# 8. Index - 17

	# move_options = [6,10,15,17,-6,-10,-15,-17]
	moves = Vector{Int}() ## empty vector for moves
	tile = Tile(knight)
	move_options = [(-2,-1),(-2,+1),(2,-1),(2,1),(1,2),(1,-2),(-1,2),(-1,-2)] ## represented in terms of (row,col) 
	current_index = TILE_TO_INDEX[tile.square]
	current_double_index = getindex(knight,board)
	for move in move_options
		new_row = current_double_index[1] + move[1]
		new_col = current_double_index[2] + move[2]
		if (new_row > 0 && new_row < 9) && (new_col > 0 && new_col < 9)
			color = knight.color
			spot_on_board = board.board[new_row,new_col]
			new_index= PAIR_TO_INDEX[(new_row,new_col)]
			if isa(spot_on_board,Empty)
				append!(moves,new_index)
			elseif spot_on_board.color != color
				append!(moves,new_index)
			end
		end
	end  ## end for
	tiles = map(x -> Tile(INDEX_TO_TILE[x]),moves)
	return tiles
end


function move!(moves::Vector{Tile},knight::Knight,board::Board,random::Bool)
	current_position = Tile(knight)
	if random
		random_index = rand(1:length(moves))
		move_to_make = moves[random_index]
	end
	old_index = TILE_TO_INDEX[current_position.square]
	new_index = TILE_TO_INDEX[move_to_make.square]
	board.board[new_index] = knight
	board.board[old_index] = Empty(old_index) 
	updated_position_char = move_to_make.square[1]
	updated_position_num = parse(Int,move_to_make.square[2])
	knight.position = (updated_position_char,updated_position_num)
end

function move!(moves::Vector{Tile},bishop::Bishop,board::Board,random::Bool)
	current_position = Tile(bishop)
	if random
		random_index = rand(1:length(moves))
		move_to_make = moves[random_index]
	end
	old_index = TILE_TO_INDEX[current_position.square]
	new_index = TILE_TO_INDEX[move_to_make.square]
	board.board[new_index] = bishop
	board.board[old_index] = Empty(old_index)
	updated_position_char = move_to_make.square[1]
	updated_position_num = parse(Int,move_to_make.square[2])
	bishop.position = (updated_position_char,updated_position_num)
end

function move!(moves::Vector{Tile},rook::Rook,board::Board,random::Bool)
	current_position = Tile(rook)
	if random
		random_index = rand(1:length(moves))
		move_to_make = moves[random_index]
	end
	old_index = TILE_TO_INDEX[current_position.square]
	new_index = TILE_TO_INDEX[move_to_make.square]
	board.board[new_index] = rook
	board.board[old_index] = Empty(old_index)
	updated_position_char = move_to_make.square[1]
	updated_position_num = parse(Int,move_to_make.square[2])
	rook.position = (updated_position_char,updated_position_num)
	rook.is_first_move = false
end

function move!(moves::Vector{Tile},queen::Queen,board::Board,random::Bool)
	current_position = Tile(queen)
	if random
		random_index = rand(1:length(moves))
		move_to_make = moves[random_index]
	end
	old_index = TILE_TO_INDEX[current_position.square]
	new_index = TILE_TO_INDEX[move_to_make.square]
	board.board[new_index] = queen
	board.board[old_index] = Empty(old_index)
	updated_position_char = move_to_make.square[1]
	updated_position_num = parse(Int,move_to_make.square[2])
	queen.position = (updated_position_char,updated_position_num)
end

function move!(moves::Vector{Tile},king::King,board::Board,random::Bool)
	current_position = Tile(king)
	if random
		random_index = rand(1:length(moves))
		move_to_make = moves[random_index]
	end
	old_index = TILE_TO_INDEX[current_position.square]
	new_index = TILE_TO_INDEX[move_to_make.square]
	board.board[new_index] = king
	board.board[old_index] = Empty(old_index)
	updated_position_char = move_to_make.square[1]
	updated_position_num = parse(Int,move_to_make.square[2])
	king.position = (updated_position_char,updated_position_num)
	king.is_first_move = false
end


function getmoves(bishop::Bishop,board::Board)
	tile = Tile(bishop)
	moves = getdiagonalmoves(tile,board)
	tiles = map(x -> Tile(INDEX_TO_TILE[x]),moves)
	return tiles
end

function getmoves(rook::Rook,board::Board)
	tile = Tile(rook)
	moves = get_rook_moves(tile,board)
	tiles = map(x -> Tile(INDEX_TO_TILE[x]),moves)
	return tiles
end

function getmoves(queen::Queen,board::Board)
	tile = Tile(queen)
	diag_moves = getdiagonalmoves(tile,board)
	rook_moves = get_rook_moves(tile,board)
	combo = union(diag_moves,rook_moves)
	tiles = map(x -> Tile(INDEX_TO_TILE[x]),combo)
	return tiles
end


function getmoves(king::King,board::Board)
	## check to see if piece can castle
end
