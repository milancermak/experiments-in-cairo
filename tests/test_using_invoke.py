import pytest


@pytest.mark.asyncio
async def test_rw(using_invoke):
    tx = await using_invoke.read_and_write_using_invoke(11, 13).invoke()
    assert tx.result.res == 0
