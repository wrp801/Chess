module Chess
    include("Moves.jl")
    include("Board.jl")
    include("Pieces.jl")
    include("Globals.jl")
    using .Pieces
    using .GameBoard
    using .Moves
    using .Globals
# Write your package code here.

## exports from the Board module
export Board, ChessBoard, ChessSquare, initialize!, print_board, getpiece, isfree, find_king, ischeck, ischeckmate, can_castle, isopposite
## exports from the Piece module
export Pawn, Knight, Bishop, Rook, Queen, King, Tile, ChessPiece, Empty
## exports from the Moves module
export getmoves, move!
## exports from the Globals module
export INDEX_TO_TILE, TILE_TO_INDEX, INDEX_TO_PAIR, PAIR_TO_INDEX

end
