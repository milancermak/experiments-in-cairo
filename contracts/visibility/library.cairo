%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func value() -> (value : felt):
end

# when deploying the main.cairo contract, this function creeps into scope - even
# though it's not imported, it will be accessible (i.e. you can execute it in a TX)
# on the main contract
# the situation is made even worse by the fact that as of Cairo 0.8.0, the @view
# modifier is still not enforced; a view function can alter a storage_var without
# any warning
@view
func increment{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (v) = value.read()
    value.write(v + 1)
    return ()
end

@view
func get_value{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        value : felt):
    let (v) = value.read()
    return (v)
end
