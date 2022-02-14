import pytest


@pytest.mark.asyncio
async def test_use_random(debug_hints):
    tx1 = await debug_hints.use_random().invoke()
    tx2 = await debug_hints.use_random().invoke()

    assert tx1.result.rnd != tx2.result.rnd
