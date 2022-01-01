%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (
    call_contract, get_contract_address, get_caller_address, CallContractResponse)

#
# exploration of call_contract syscall
#

# call_contract takes 4 arguments:
#    contract_address : felt
#    function_selector : felt
#    calldata_size : felt
#    calldata : felt*

# a function that calls self via the call_contract syscall
# ( ಠ ʖ̯ ಠ )
# note that because it's using syscall, the target function has to be @external

@external
func call_self{syscall_ptr : felt*}(selector : felt) -> (retdata_len : felt, retdata : felt*):
    alloc_locals

    let (self) = get_contract_address()
    let (local ptr : felt*) = alloc()

    let response : CallContractResponse = call_contract(self, selector, 0, ptr)
    return (response.retdata_size, response.retdata)
end

@external
func forever_one() -> (one : felt):
    return (1)
end

@external
func call_func_single_felt{syscall_ptr : felt*}(target_address : felt, selector : felt) -> (
        retdata_len : felt, retdata : felt*):
    alloc_locals

    let (local calldata_ptr_start : felt*) = alloc()
    let calldata_ptr = calldata_ptr_start
    assert calldata_ptr[0] = 9
    let calldata_ptr = calldata_ptr + 1

    let response : CallContractResponse = call_contract(
        target_address, selector, calldata_ptr - calldata_ptr_start, calldata_ptr_start)
    return (response.retdata_size, response.retdata)
end

@external
func call_func_felt_arr{syscall_ptr : felt*}(target_address : felt, selector : felt) -> (
        retdata_len : felt, retdata : felt*):
    alloc_locals

    let (local calldata_ptr_start : felt*) = alloc()
    let calldata_ptr = calldata_ptr_start

    # arr_len (felt) argument
    assert [calldata_ptr] = 6
    let calldata_ptr = calldata_ptr + 1

    # arr (felt*) argument
    assert [calldata_ptr] = 1
    let calldata_ptr = calldata_ptr + 1
    assert [calldata_ptr] = 1
    let calldata_ptr = calldata_ptr + 1
    assert [calldata_ptr] = 2
    let calldata_ptr = calldata_ptr + 1
    assert [calldata_ptr] = 3
    let calldata_ptr = calldata_ptr + 1
    assert [calldata_ptr] = 5
    let calldata_ptr = calldata_ptr + 1
    assert [calldata_ptr] = 8
    let calldata_ptr = calldata_ptr + 1

    let response : CallContractResponse = call_contract(
        target_address, selector, calldata_ptr - calldata_ptr_start, calldata_ptr_start)
    return (response.retdata_size, response.retdata)
end

@external
func call_func_new_phone_who_dis{syscall_ptr : felt*}(target_address : felt, selector : felt) -> (
        retdata_len : felt, retdata : felt*):
    alloc_locals

    let (local calldata_ptr : felt*) = alloc()
    let response : CallContractResponse = call_contract(target_address, selector, 0, calldata_ptr)
    return (response.retdata_size, response.retdata)
end

#
# experimenting with interfaces
# https://www.cairo-lang.org/docs/hello_starknet/calling_contracts.html
#

@contract_interface
namespace INotAToken:
    func mint(amount : felt):
    end

    func mint_to(amount : felt, to_addr_len : felt, to_addr : felt*):
    end

    func get_balance(addr : felt) -> (balance : felt):
    end
end

@external
func call_mint{syscall_ptr : felt*, range_check_ptr}(token_addr : felt, amount : felt):
    INotAToken.mint(contract_address=token_addr, amount=amount)
    return ()
end

@external
func call_mint_to{syscall_ptr : felt*, range_check_ptr}(
        token_addr : felt, amount : felt, to_addr_len : felt, to_addr : felt*):
    INotAToken.mint_to(
        contract_address=token_addr, amount=amount, to_addr_len=to_addr_len, to_addr=to_addr)
    return ()
end