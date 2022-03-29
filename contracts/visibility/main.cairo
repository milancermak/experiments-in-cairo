%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from contracts.visibility.library import get_value

@view
func ask_for_current_value{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        value : felt):
    let (v) = get_value()
    return (v)
end
