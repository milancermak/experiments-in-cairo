%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

#
# different ways how to model state and work with the data structures in a cairo contract
#

#
# constants
#

# cairo can have constants, only integers tho
# https://www.cairo-lang.org/docs/how_cairo_works/consts.html#consts
const ANSWER = 42

@external
func give_me_the_answer() -> (answer : felt):
    return (ANSWER)
end

#
# simple single value storage_var
#

# declared via @storage_var decorator
# the value is initialized to 0
@storage_var
func balance() -> (amount : felt):
end

# there's no implicit setter or getter, we have to write them

@view
func get_balance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        amount : felt):
    let (amount) = balance.read()
    return (amount)
end

@external
func set_balance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(amount : felt):
    balance.write(amount)
    return ()
end

#
# storage_var holding a compound type
#

# a @storage_var can hold compound data types like structs or tuples,
# but these have to be felts-only types

# here's an example of a compound storage_var using a struct
# https://www.cairo-lang.org/docs/how_cairo_works/consts.html#typed-references
# https://starknet.io/docs/hello_starknet/more_features.html#storage-variable-with-struct-arguments
struct Point:
    member x : felt
    member y : felt
    member z : felt
end

@storage_var
func player_position_struct(player : felt) -> (position : Point):
end

@view
func get_player_position_struct{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        player : felt) -> (position : Point):
    # note that reading the value like this also works, but I prefer
    # the version below, which is explicitely typed
    #
    # let (player_position) = player_position_struct.read(player)
    # return (player_position)

    let player_position : Point = player_position_struct.read(player)
    return (player_position)
end

@external
func set_player_position_struct_as_xyz{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        player : felt, x : felt, y : felt, z : felt):
    let position : Point = Point(x=x, y=y, z=y)
    player_position_struct.write(player, position)
    return ()
end

@external
func set_player_position_struct_directly{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        player : felt, position : Point):
    player_position_struct.write(player, position)
    return ()
end

# here's an example of a compound storage_var using a tuple
# https://www.cairo-lang.org/docs/how_cairo_works/consts.html#tuples
# https://www.cairo-lang.org/docs/how_cairo_works/functions.html#return-tuple
# https://starknet.io/docs/hello_starknet/more_features.html#storage-variable-with-multiple-values
@storage_var
func player_position_tuple(player : felt) -> (position : (felt, felt, felt)):
end

@view
func get_player_position_tuple{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        player : felt) -> (position : (felt, felt, felt)):
    let (xyz) = player_position_tuple.read(player)
    return ((xyz[0], xyz[1], xyz[2]))
end

@external
func set_player_position_tuple_as_xyz{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        player : felt, x : felt, y : felt, z : felt):
    player_position_tuple.write(player, (x, y, z))
    return ()
end

@external
func set_player_position_tuple_as_tuple{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        player : felt, position_tuple : (felt, felt, felt)):
    player_position_tuple.write(player, position_tuple)
    return ()
end

#
# a storage_var with multiple arguments serves as a mapping / dict
#
@storage_var
func manhattan(street : felt, avenue : felt) -> (star_rating : felt):
end

@view
func get_manhattan_rating{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        street : felt, avenue : felt) -> (star_rating : felt):
    let (stars) = manhattan.read(street, avenue)
    return (stars)
end

@external
func set_manhattan_rating{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        street : felt, avenue : felt, rating : felt):
    manhattan.write(street, avenue, rating)
    return ()
end

#
# struct as enum
# there's a way how to use structs as enums
# https://hackmd.io/@RoboTeddy/BJZFu56wF#Struct-enum-pattern
#
struct Piece:
    # None is going to be assigned the value 0, which is the
    # default for a felt, so we might want to represent an
    # empty field with 0 as well
    member None : felt
    member WhiteKing : felt
    member WhiteQueen : felt
    member WhiteBishop : felt
    member WhiteKnight : felt
    member WhiteRook : felt
    member WhitePawn : felt
    member BlackKing : felt
    member BlackQueen : felt
    member BlackBishop : felt
    member BlackKnight : felt
    member BlackRook : felt
    member BlackPawn : felt
end

# here's one way how a chess game could be modelled...or not :)
# take it with a grain of salt, it's an exploration of limits

@storage_var
func chess_board(game_id : felt, letter : felt, number : felt) -> (piece : felt):
end

@external
func init_chess_game{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        game_id : felt):
    # https://dilbert.com/strip/2001-10-25
    tempvar game_id = 9

    chess_board.write(game_id, 'a', 8, Piece.BlackRook)
    chess_board.write(game_id, 'b', 8, Piece.BlackKnight)
    chess_board.write(game_id, 'c', 8, Piece.BlackBishop)
    chess_board.write(game_id, 'd', 8, Piece.BlackQueen)
    chess_board.write(game_id, 'e', 8, Piece.BlackKing)
    chess_board.write(game_id, 'f', 8, Piece.BlackBishop)
    chess_board.write(game_id, 'g', 8, Piece.BlackKnight)
    chess_board.write(game_id, 'h', 8, Piece.BlackRook)

    chess_board.write(game_id, 'a', 7, Piece.BlackPawn)
    chess_board.write(game_id, 'b', 7, Piece.BlackPawn)
    chess_board.write(game_id, 'c', 7, Piece.BlackPawn)
    chess_board.write(game_id, 'd', 7, Piece.BlackPawn)
    chess_board.write(game_id, 'e', 7, Piece.BlackPawn)
    chess_board.write(game_id, 'f', 7, Piece.BlackPawn)
    chess_board.write(game_id, 'g', 7, Piece.BlackPawn)
    chess_board.write(game_id, 'h', 7, Piece.BlackPawn)

    chess_board.write(game_id, 'a', 2, Piece.WhitePawn)
    chess_board.write(game_id, 'b', 2, Piece.WhitePawn)
    chess_board.write(game_id, 'c', 2, Piece.WhitePawn)
    chess_board.write(game_id, 'd', 2, Piece.WhitePawn)
    chess_board.write(game_id, 'e', 2, Piece.WhitePawn)
    chess_board.write(game_id, 'f', 2, Piece.WhitePawn)
    chess_board.write(game_id, 'g', 2, Piece.WhitePawn)
    chess_board.write(game_id, 'h', 2, Piece.WhitePawn)

    chess_board.write(game_id, 'a', 1, Piece.WhiteRook)
    chess_board.write(game_id, 'b', 1, Piece.WhiteKnight)
    chess_board.write(game_id, 'c', 1, Piece.WhiteBishop)
    chess_board.write(game_id, 'd', 1, Piece.WhiteQueen)
    chess_board.write(game_id, 'e', 1, Piece.WhiteKing)
    chess_board.write(game_id, 'f', 1, Piece.WhiteBishop)
    chess_board.write(game_id, 'g', 1, Piece.WhiteKnight)
    chess_board.write(game_id, 'h', 1, Piece.WhiteRook)

    return (game_id)
end

@view
func get_chess_game_board{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        game_id : felt) -> (
        board : (felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt, felt)):
    let (a1) = chess_board.read(game_id, 'a', 1)
    let (b1) = chess_board.read(game_id, 'b', 1)
    let (c1) = chess_board.read(game_id, 'c', 1)
    let (d1) = chess_board.read(game_id, 'd', 1)
    let (e1) = chess_board.read(game_id, 'e', 1)
    let (f1) = chess_board.read(game_id, 'f', 1)
    let (g1) = chess_board.read(game_id, 'g', 1)
    let (h1) = chess_board.read(game_id, 'h', 1)

    let (a2) = chess_board.read(game_id, 'a', 2)
    let (b2) = chess_board.read(game_id, 'b', 2)
    let (c2) = chess_board.read(game_id, 'c', 2)
    let (d2) = chess_board.read(game_id, 'd', 2)
    let (e2) = chess_board.read(game_id, 'e', 2)
    let (f2) = chess_board.read(game_id, 'f', 2)
    let (g2) = chess_board.read(game_id, 'g', 2)
    let (h2) = chess_board.read(game_id, 'h', 2)

    let (a3) = chess_board.read(game_id, 'a', 3)
    let (b3) = chess_board.read(game_id, 'b', 3)
    let (c3) = chess_board.read(game_id, 'c', 3)
    let (d3) = chess_board.read(game_id, 'd', 3)
    let (e3) = chess_board.read(game_id, 'e', 3)
    let (f3) = chess_board.read(game_id, 'f', 3)
    let (g3) = chess_board.read(game_id, 'g', 3)
    let (h3) = chess_board.read(game_id, 'h', 3)

    let (a4) = chess_board.read(game_id, 'a', 4)
    let (b4) = chess_board.read(game_id, 'b', 4)
    let (c4) = chess_board.read(game_id, 'c', 4)
    let (d4) = chess_board.read(game_id, 'd', 4)
    let (e4) = chess_board.read(game_id, 'e', 4)
    let (f4) = chess_board.read(game_id, 'f', 4)
    let (g4) = chess_board.read(game_id, 'g', 4)
    let (h4) = chess_board.read(game_id, 'h', 4)

    let (a5) = chess_board.read(game_id, 'a', 5)
    let (b5) = chess_board.read(game_id, 'b', 5)
    let (c5) = chess_board.read(game_id, 'c', 5)
    let (d5) = chess_board.read(game_id, 'd', 5)
    let (e5) = chess_board.read(game_id, 'e', 5)
    let (f5) = chess_board.read(game_id, 'f', 5)
    let (g5) = chess_board.read(game_id, 'g', 5)
    let (h5) = chess_board.read(game_id, 'h', 5)

    let (a6) = chess_board.read(game_id, 'a', 6)
    let (b6) = chess_board.read(game_id, 'b', 6)
    let (c6) = chess_board.read(game_id, 'c', 6)
    let (d6) = chess_board.read(game_id, 'd', 6)
    let (e6) = chess_board.read(game_id, 'e', 6)
    let (f6) = chess_board.read(game_id, 'f', 6)
    let (g6) = chess_board.read(game_id, 'g', 6)
    let (h6) = chess_board.read(game_id, 'h', 6)

    let (a7) = chess_board.read(game_id, 'a', 7)
    let (b7) = chess_board.read(game_id, 'b', 7)
    let (c7) = chess_board.read(game_id, 'c', 7)
    let (d7) = chess_board.read(game_id, 'd', 7)
    let (e7) = chess_board.read(game_id, 'e', 7)
    let (f7) = chess_board.read(game_id, 'f', 7)
    let (g7) = chess_board.read(game_id, 'g', 7)
    let (h7) = chess_board.read(game_id, 'h', 7)

    let (a8) = chess_board.read(game_id, 'a', 8)
    let (b8) = chess_board.read(game_id, 'b', 8)
    let (c8) = chess_board.read(game_id, 'c', 8)
    let (d8) = chess_board.read(game_id, 'd', 8)
    let (e8) = chess_board.read(game_id, 'e', 8)
    let (f8) = chess_board.read(game_id, 'f', 8)
    let (g8) = chess_board.read(game_id, 'g', 8)
    let (h8) = chess_board.read(game_id, 'h', 8)

    return (
        (a1, b1, c1, d1, e1, f1, g1, h1,
        a2, b2, c2, d2, e2, f2, g2, h2,
        a3, b3, c3, d3, e3, f3, g3, h3,
        a4, b4, c4, d4, e4, f4, g4, h4,
        a5, b5, c5, d5, e5, f5, g5, h5,
        a6, b6, c6, d6, e6, f6, g6, h6,
        a7, b7, c7, d7, e7, f7, g7, h7,
        a8, b8, c8, d8, e8, f8, g8, h8))
end
