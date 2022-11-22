module Chess
    include("Globals.jl")
    include("Pieces.jl")
    include("Board.jl")
    include("Moves.jl")

    # using .Pieces
    # using .GameBoard
    # using .Moves
    using .Globals
    ## exports from the Piece module
    export Pawn, Knight, Bishop, Rook, Queen, Queen, King, Tile, ChessPiece, Empty, get_tile, get_single_index, getpair
    ## exports from the Board module
    export ChessBoard, Board, ChessSquare, initialize!, print_board, getpiece, isfree, find_king, ischeck, ischeckmate, can_castle, isopposite
    ## exports from the Moves module
    export getmoves, move!
    # exports from the Globals module
	export INDEX_TO_TILE, TILE_TO_INDEX, INDEX_TO_PAIR, PAIR_TO_INDEX
end
