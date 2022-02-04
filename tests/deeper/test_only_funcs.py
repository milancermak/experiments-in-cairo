import pytest


@pytest.mark.asyncio
async def test_read_write(only_funcs):
    key = 42
    value = 101

    tx_info = await only_funcs.get_value_by_key(key).invoke()
    assert tx_info.result.value == 0

    await only_funcs.set_value_to_key(key, value).invoke()
    tx_info = await only_funcs.get_value_by_key(key).invoke()
    assert tx_info.result.value == value
