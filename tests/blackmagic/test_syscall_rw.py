import pytest

from starkware.starknet.public.abi import get_storage_var_address

@pytest.mark.asyncio
async def test_read_storage_var_addrs(srw):
    i = 20
    tx = await srw.read_storage_var_addrs(i).invoke()
    assert tx.result.foo_addr == get_storage_var_address("foo")
    assert tx.result.bar_addr == get_storage_var_address("bar", i)


@pytest.mark.asyncio
async def test_writing_storage_var_using_syscall(srw):
    foo_addr = get_storage_var_address("foo")
    foo_val = 20
    tx = await srw.write_storage_var_using_syscall(foo_addr, foo_val).invoke()

    tx = await srw.get_foo().invoke()
    assert tx.result.val == foo_val
    # this takes 46 steps
    # print(tx.call_info.execution_resources.n_steps)

    tx = await srw.read_storage_var_using_syscall(foo_addr).invoke()
    assert tx.result.val == foo_val
    # this takes 30 steps
    # print(tx.call_info.execution_resources.n_steps)

    for idx in range(5):
        addr = get_storage_var_address("bar", idx)
        val = idx * 10
        await srw.write_storage_var_using_syscall(addr, val).invoke()
        tx = await srw.get_bar(idx).invoke()
        assert tx.result.val == val

    # using syscalls, we can even write to and read from a variable that
    # has not been declared via @storage_var
    faux_addr = get_storage_var_address("nonexistent")
    faux_val = 42
    await srw.write_storage_var_using_syscall(faux_addr, faux_val).invoke()
    tx = await srw.read_storage_var_using_syscall(faux_addr).invoke()
    assert tx.result.val == faux_val


@pytest.mark.asyncio
async def test_rw_syscalls_with_struct(srw):
    box = (20, 20, 60)
    boxes_addr = get_storage_var_address("boxes", *box)
    tx = await srw.read_storage_var_using_syscall(boxes_addr).invoke()
    assert tx.result.val == 0

    boxes_count = 3
    await srw.write_storage_var_using_syscall(boxes_addr, boxes_count).invoke()
    tx = await srw.read_storage_var_using_syscall(boxes_addr).invoke()
    assert tx.result.val == boxes_count

    # same as above, this way we can write to a storage_var that has not been
    # declared; it's all using an addr, regardless if it's a struct or not
