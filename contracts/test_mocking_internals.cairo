%lang starknet

from starkware.starknet.common.syscalls import (
    get_block_number, get_block_timestamp, get_caller_address)

@view
func what_block_number{syscall_ptr : felt*}() -> (block_number : felt):
    let (block_number) = get_block_number()
    return (block_number)
end

@view
func what_block_timestamp{syscall_ptr : felt*}() -> (block_timestamp : felt):
    let (block_timestamp) = get_block_timestamp()
    return (block_timestamp)
end

@view
func what_caller_address{syscall_ptr : felt*}() -> (caller_address : felt):
    let (caller_address) = get_caller_address()
    return (caller_address)
end
