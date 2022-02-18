import pytest


@pytest.mark.asyncio
async def test_sum(jmp_loop):
    arr = list(range(40))
    tx = await jmp_loop.sum(arr).invoke()
    assert tx.result.res == sum(arr)
    print(tx)


@pytest.mark.asyncio
async def test_exp(jmp_loop):
    x = 8
    a = 42
    n = 16
    r = x * a ** n

    tx_r = await jmp_loop.exp_recr(x, a, n).invoke()
    tx_i = await jmp_loop.exp_inst(x, a, n).invoke()

    assert tx_r.result.res == r
    assert tx_i.result.res == r
    assert tx_r.call_info.cairo_usage.n_steps == tx_i.call_info.cairo_usage.n_steps
