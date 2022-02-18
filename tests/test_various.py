import pytest
from starkware.starkware_utils.error_handling import StarkException


@pytest.mark.asyncio
async def test_loop_and_write_and_reset(various):
    original_value = (await various.get_temp_counter().invoke()).result.res
    arr = list(range(1, 31))
    tx = await various.loop_and_write_and_reset(arr).invoke()
    # print(tx)
    after_computation_value = (await various.get_temp_counter().invoke()).result.res
    assert original_value == after_computation_value


@pytest.mark.asyncio
async def test_if_else(various):
    assert (await various.if_else(0).invoke()).result.res == 18
    assert (await various.if_else(1).invoke()).result.res == 12


@pytest.mark.asyncio
async def test_using_with_attr(various):
    assert (await various.using_with_attr(0).invoke()).result.res == 1
    with pytest.raises(StarkException) as e:
        await various.using_with_attr(1).invoke()
