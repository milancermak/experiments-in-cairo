%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from deeper.only_vars import a_map

@view
func get_value_by_key{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : felt) -> (value : felt):
    let (value) = a_map.read(key)
    return (value)
end

@external
func set_value_to_key{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : felt, value : felt):
    a_map.write(key, value)
    return ()
end
