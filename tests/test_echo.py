import pytest

from starkware.starkware_utils.error_handling import StarkException


@pytest.mark.asyncio
async def test_yell_echo(echo1, echo2):
    with pytest.raises(StarkException) as exc_info:
        await echo1.yell(echo2.contract_address).call()
    assert "maximum recursion depth exceeded" in str(exc_info.value)
