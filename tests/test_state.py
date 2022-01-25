from collections import namedtuple
import pytest


Point = namedtuple("Point", ["x", "y", "z"])


@pytest.mark.asyncio
async def test_const_reading(state):
    tx_info = await state.give_me_the_answer().invoke()
    assert tx_info.result.answer == 42


@pytest.mark.asyncio
async def test_single_value_storage_var(state):
    tx_info = await state.get_balance().invoke()
    assert tx_info.result.amount == 0

    await state.set_balance(100).invoke()

    tx_info = await state.get_balance().invoke()
    assert tx_info.result.amount == 100


@pytest.mark.asyncio
async def test_storage_var_struct(state):
    player = 1

    tx_info = await state.get_player_position_struct(player).invoke()
    position = tx_info.result.position

    assert position.x == 0
    assert position.y == 0
    assert position.z == 0

    await state.set_player_position_struct_as_xyz(player, 99, 99, 99).invoke()
    tx_info = await state.get_player_position_struct(player).invoke()
    position = tx_info.result.position

    assert position.x == 99
    assert position.y == 99
    assert position.z == 99

    new_position = Point(2, 4, 6)
    await state.set_player_position_struct_directly(player, new_position).invoke()
    tx_info = await state.get_player_position_struct(player).invoke()
    position = tx_info.result.position

    assert position.x == 2
    assert position.y == 4
    assert position.z == 6


@pytest.mark.asyncio
async def test_storage_var_tuple(state):
    player = 8

    tx_info = await state.get_player_position_tuple(player).invoke()
    position = tx_info.result.position

    assert position == (0, 0, 0)

    await state.set_player_position_tuple_as_xyz(player, 99, 99, 99).invoke()
    tx_info = await state.get_player_position_tuple(player).invoke()
    position = tx_info.result.position

    assert position == (99, 99, 99)

    new_position = (2, 4, 6)
    await state.set_player_position_tuple_as_tuple(player, new_position).invoke()
    tx_info = await state.get_player_position_tuple(player).invoke()
    position = tx_info.result.position

    assert position == new_position


@pytest.mark.asyncio
async def test_mapping_storage_var(state):
    street = 53
    avenue = 3
    tx_info = await state.get_manhattan_rating(street, avenue).invoke()
    rating = tx_info.result.star_rating

    assert rating == 0

    new_rating = 5
    await state.set_manhattan_rating(street, avenue, new_rating).invoke()
    tx_info = await state.get_manhattan_rating(street, avenue).invoke()
    rating = tx_info.result.star_rating

    assert rating == new_rating


@pytest.mark.asyncio
async def test_init_chess_game(state):
    from enum import Enum

    class Piece(Enum):
        NoPiece = 0
        WhiteKing = 1
        WhiteQueen = 2
        WhiteBishop = 3
        WhiteKnight = 4
        WhiteRook = 5
        WhitePawn = 6
        BlackKing = 7
        BlackQueen = 8
        BlackBishop = 9
        BlackKnight = 10
        BlackRook = 11
        BlackPawn = 12

    tx_info = await state.init_chess_game().invoke()
    game_id = tx_info.result.game_id

    assert game_id == 9

    tx_info = await state.get_chess_game_board(game_id).invoke()
    board = tx_info.result.board

    assert len(board) == 64

    first_row = board[:8]
    assert first_row == (
        Piece.WhiteRook.value,
        Piece.WhiteKnight.value,
        Piece.WhiteBishop.value,
        Piece.WhiteQueen.value,
        Piece.WhiteKing.value,
        Piece.WhiteBishop.value,
        Piece.WhiteKnight.value,
        Piece.WhiteRook.value,
    )

    second_row = board[8:16]
    assert second_row == (
        Piece.WhitePawn.value,
        Piece.WhitePawn.value,
        Piece.WhitePawn.value,
        Piece.WhitePawn.value,
        Piece.WhitePawn.value,
        Piece.WhitePawn.value,
        Piece.WhitePawn.value,
        Piece.WhitePawn.value,
    )

    seventh_row = board[48:56]
    assert seventh_row == (
        Piece.BlackPawn.value,
        Piece.BlackPawn.value,
        Piece.BlackPawn.value,
        Piece.BlackPawn.value,
        Piece.BlackPawn.value,
        Piece.BlackPawn.value,
        Piece.BlackPawn.value,
        Piece.BlackPawn.value,
    )

    eight_row = board[56:]
    assert eight_row == (
        Piece.BlackRook.value,
        Piece.BlackKnight.value,
        Piece.BlackBishop.value,
        Piece.BlackQueen.value,
        Piece.BlackKing.value,
        Piece.BlackBishop.value,
        Piece.BlackKnight.value,
        Piece.BlackRook.value,
    )
