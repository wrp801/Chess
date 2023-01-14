module Chess
    include("Globals.jl")
    include("Pieces.jl")
    include("Board.jl")
    include("Moves.jl")
    include("Helpers.jl")

    # using .Pieces
    # using .GameBoard
    # using .Moves
    using .Globals
    ## exports from the Piece module
    export Pawn, Knight, Bishop, Rook, Queen, Queen, King, Tile, ChessPiece, Empty, get_tile, get_single_index, getpair
    ## exports from the Board module
    export ChessBoard, Board, ChessSquare, initialize!, print_board, getpiece, isfree, find_king, ischeck, ischeckmate, can_castle, isopposite, can_castle_kingside, readfen!, Fen, WHITE_PIECES_ACTIVE, BLACK_PIECES_ACTIVE, BLACK_TILES_ATTACKED, WHITE_TILES_ATTACKED, update!
    ## exports from Helpers
    export attackingtiles
    ## exports from the Moves module
    export getmoves, move!
    # exports from the Globals module
	export INDEX_TO_TILE, TILE_TO_INDEX, INDEX_TO_PAIR, PAIR_TO_INDEX
end
