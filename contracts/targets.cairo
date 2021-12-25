%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

#
# this contract serves only as a target for external calls from calls.cairo
#

@external
func plus_one{syscall_ptr : felt*}(value : felt) -> (value_plus_one : felt):
    return (value + 1)
end

@external
func sum{syscall_ptr : felt*}(arr_len : felt, arr : felt*) -> (result : felt):
    let (sum) = sum_values(0, arr_len, arr)
    return (sum)
end

func sum_values(agg : felt, arr_len : felt, arr : felt*) -> (result : felt):
    if arr_len == 0:
        return (agg)
    end
    return sum_values(agg + arr[0], arr_len - 1, arr + 1)
end

@view
func new_phone_who_dis{syscall_ptr : felt*}() -> (dis : felt):
    let (who) = get_caller_address()
    return (who)
end

#
# not a token...
# used to experiment with @contract_interface in calls.cairo
#

@storage_var
func balances(address : felt) -> (balance : felt):
end

@external
func mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(amount : felt):
    let (address) = get_caller_address()
    let (current_amount) = balances.read(address)
    balances.write(address, current_amount + amount)
    return ()
end

@external
func mint_to{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        amount : felt, to_addr_len : felt, to_addr : felt*):
    internal_mint_to(amount, to_addr_len, to_addr)
    return ()
end

func internal_mint_to{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        amount : felt, to_addr_len : felt, to_addr : felt*):
    if to_addr_len == 0:
        return ()
    end

    let address : felt = [to_addr]
    let (current_amount) = balances.read(address)
    balances.write(address, current_amount + amount)
    return internal_mint_to(amount, to_addr_len - 1, to_addr + 1)
end

@view
func get_balance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        address : felt) -> (balance : felt):
    let (balance) = balances.read(address)
    return (balance)
end
