using ..Globals


########################################
#         Set of Tiles Attacked
########################################

BLACK_PIECES_ACTIVE = Vector{ChessPiece}()
WHITE_PIECES_ACTIVE = Vector{ChessPiece}()
BLACK_TILES_ATTACKED = Vector{Int}()
WHITE_TILES_ATTACKED = Vector{Int}()



########################################
#          Data type definitions                       
########################################
abstract type ChessBoard end
## This is not used
mutable struct ChessSquare <: ChessBoard
	isempty::Bool
	piece::Union{Nothing,ChessPiece}
	color::Char
end

mutable struct Fen
	placement::String ## where the pieces are on the board
	turn::String ## whether it is white or black who moves first
	castling::String ## the castling rights of white and black
	enpassant::String ## possible en passant squares
	halfmove::String ## number of moves each side has made
	fullmove::String ## number of completed turns (is incremented when black moves)
end

mutable struct Board  <: ChessBoard
	board::Array{ChessPiece}
    fen::Fen
end

"""
Constructor for the board type

"""
function Board()
	board = Array{ChessPiece}(undef,8,8);
    fen = Fen(STARTING_FEN)
	return Board(board,fen)
end


"""
Constructor for the Fen type
"""
function Fen(fen::String)
    splits = split(fen," ") ## this will separate the fen string into appropriate actions
    return Fen(splits[1],splits[2],splits[3],splits[4],splits[5],splits[6])
end


#######################################
#          Functions for board                       
########################################
function update!(piece_vector::Vector{ChessPiece},tile_vector::Vector{Int},board::Board)
    pawns = filter(x -> isa(x,Pawn),piece_vector)
    other_pieces = filter(x -> !isa(x,Pawn), piece_vector)

    pawn_attacks = map(x -> attackingtiles(x,board), pawns)
    other_attacks = map(x -> getmoves(x,board),other_pieces)

    return union(pawn_attacks,other_attacks)

end


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
                        piece = Rook('b',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					elseif char == 'n'
                        piece = Knight('b',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					elseif char == 'b'
                        piece = Bishop('b',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					elseif char == 'k'
                        piece = King('b',cid,(rid,cid)) 
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					elseif char == 'q'
                        piece = Queen('b',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					elseif char == 'p'
                        piece = Pawn('b',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					## white pieces
					elseif char == 'R'
                        piece = Rook('w',cid,(rid,cid))
						board.board[rid,cid] = Rook('w',cid,(rid,cid))
                        push!(WHITE_PIECES_ACTIVE,piece)
					elseif char == 'N'
                        piece = Knight('w',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(WHITE_PIECES_ACTIVE,piece)
					elseif char == 'B'
                        piece = Bishop('w',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(WHITE_PIECES_ACTIVE,piece)
					elseif char == 'K'
                        piece = King('w',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(WHITE_PIECES_ACTIVE,piece)
					elseif char == 'Q'
                        piece = Queen('w',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(WHITE_PIECES_ACTIVE,piece)
					elseif char == 'P'
                        piece = Pawn('w',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(WHITE_PIECES_ACTIVE,piece)
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
				else
					if char == 'r'
                        piece = Rook('b',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					elseif char == 'n'
                        piece = Knight('b',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					elseif char == 'b'
                        piece = Bishop('b',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					elseif char == 'k'
                        piece = King('b',cid,(rid,cid)) 
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					elseif char == 'q'
                        piece = Queen('b',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					elseif char == 'p'
                        piece = Pawn('b',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(BLACK_PIECES_ACTIVE,piece)
					## white pieces
					elseif char == 'R'
                        piece = Rook('w',cid,(rid,cid))
						board.board[rid,cid] = Rook('w',cid,(rid,cid))
                        push!(WHITE_PIECES_ACTIVE,piece)
					elseif char == 'N'
                        piece = Knight('w',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(WHITE_PIECES_ACTIVE,piece)
					elseif char == 'B'
                        piece = Bishop('w',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(WHITE_PIECES_ACTIVE,piece)
					elseif char == 'K'
                        piece = King('w',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(WHITE_PIECES_ACTIVE,piece)
					elseif char == 'Q'
                        piece = Queen('w',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(WHITE_PIECES_ACTIVE,piece)
					elseif char == 'P'
                        piece = Pawn('w',cid,(rid,cid))
						board.board[rid,cid] = piece
                        push!(WHITE_PIECES_ACTIVE,piece)
					end
					cid +=1
				end
			end
        end
		rid-=1
    end
    ## now populate the attacked squares 

    ## black pieces 

end


"""
Returns a list of all the tiles that are under attack by the provided color
"""
# function get_attacked_squares(board::Board, color::char)::Vector{Tile}
#     if color == 'w'
#         for piece in WHITE_PIECES_ACTIVE
#
#
#         end
#
#     elseif color == 'b'
#         for piece in BLACK_PIECES_ACTIVE
#
#         end
#
#     end
#     
# end
#



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
