# requires Cairo >= 0.8.0 because of new
# credit goes to Lior Goldberg
# https://canary.discord.com/channels/793094838509764618/793094838987128843/955560517248909394

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.invoke import invoke
from starkware.cairo.common.registers import get_label_location
from starkware.starknet.common.syscalls import get_caller_address

@storage_var
func foo(x : felt) -> (y : felt):
end

@external
func read_and_write_using_invoke{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        x : felt, y : felt) -> (res : felt):
    alloc_locals

    # Read.
    let (foo_read) = get_label_location(foo.read)
    tempvar args = cast(new(syscall_ptr, pedersen_ptr, range_check_ptr, x), felt*)
    invoke(foo_read, n_args=4, args=args)
    # Handle returned implicit arguments (invoke doesn't know how to handle them).
    let syscall_ptr = cast([ap - 4], felt*)
    let pedersen_ptr = cast([ap - 3], HashBuiltin*)
    let range_check_ptr = [ap - 2]
    local res = [ap - 1]

    # Write.
    let (foo_write) = get_label_location(foo.write)
    tempvar args = cast(new(syscall_ptr, pedersen_ptr, range_check_ptr, x, y), felt*)
    invoke(foo_write, n_args=5, args=args)
    let syscall_ptr = cast([ap - 3], felt*)
    let pedersen_ptr = cast([ap - 2], HashBuiltin*)
    let range_check_ptr = [ap - 1]

    return (res=res)
end
