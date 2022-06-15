%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import storage_read, storage_write

@storage_var
func foo() -> (x : felt):
end

@storage_var
func bar(i : felt) -> (x : felt):
end

struct Box:
    member width : felt
    member height : felt
    member depth : felt
end

@storage_var
func boxes(b : Box) -> (count : felt):
end

@view
func read_storage_var_addrs{pedersen_ptr : HashBuiltin*, range_check_ptr}(bar_i : felt) -> (
    foo_addr : felt, bar_addr : felt
):
    let (a) = foo.addr()  # a = 766151770395363889994273252081996607712327869204808632459022800692259163213
    let (b) = bar.addr(bar_i)
    return (a, b)
end

@view
func get_foo{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (val : felt):
    let (val) = foo.read()
    return (val)
end

@view
func get_bar{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(i : felt) -> (
    val : felt
):
    let (val) = bar.read(i)
    return (val)
end

# write to a storage_var that's passed as an address in an arg
@external
func write_storage_var_using_syscall{syscall_ptr : felt*}(storage_var_addr : felt, val : felt):
    storage_write(storage_var_addr, val)
    return ()
end

# read from a storage_var that's passed as an address in an arg
@view
func read_storage_var_using_syscall{syscall_ptr : felt*}(storage_var_addr : felt) -> (val : felt):
    let (val) = storage_read(storage_var_addr)
    return (val)
end
