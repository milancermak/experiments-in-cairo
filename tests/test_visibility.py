import pytest


@pytest.mark.asyncio
async def test_visibility(visibility_main):
    tx = await visibility_main.ask_for_current_value().invoke()
    assert tx.result.value == 0

    await visibility_main.increment().invoke()  # triggers "hidden" side-effect

    tx = await visibility_main.ask_for_current_value().invoke()
    assert tx.result.value == 1

    # calling get_value, which is only imported in main.cairo
    tx2 = await visibility_main.get_value().invoke()
    assert tx2.result.value == tx.result.value
