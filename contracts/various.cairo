%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

#
# pattern of doing computation and keeping intermediary state in a
# @storage_var but restoring it to its original (empty) value afterwads
# as not to produce a state diff
#

@storage_var
func temp_counter() -> (cnt : felt):
end

@external
func loop_and_write_and_reset{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        arr_len : felt, arr : felt*):
    alloc_locals

    # I'm keeping the original value so I can restore it afterwards,
    # that way, there's no state change to be propagated back to L1
    # hence the tx is cheap, but I could still retrieve intermediary
    # state changes in the storage_var inside the tx

    let (original_value) = temp_counter.read()
    %{ print("original value: ", ids.original_value) %}
    looper_writer(arr_len, arr)
    temp_counter.write(original_value)
    return ()
end

func looper_writer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        arr_len : felt, arr : felt*):
    alloc_locals

    let (v) = temp_counter.read()
    %{ print("current value: ", ids.v) %}

    if arr_len == 0:
        return ()
    end

    temp_counter.write([arr])
    return looper_writer(arr_len - 1, arr + 1)
end

@view
func get_temp_counter{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        res : felt):
    let (v) = temp_counter.read()
    return (v)
end

#
# -----------------------------------------------------------------------------
#

@view
func if_else(v : felt) -> (res : felt):
    # works without alloc_locals
    let x = 10
    if v == 0:
        tempvar y = 8
    else:
        tempvar y = 2
    end
    return (x + y)
end

#
# -----------------------------------------------------------------------------
#

@view
func using_with_attr(a : felt) -> (res : felt):
    with_attr error_message("ngmi"):
        assert a = 0
    end
    return (1)
end
