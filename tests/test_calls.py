import pytest

from starkware.starknet.public.abi import get_selector_from_name


@pytest.mark.asyncio
async def test_call_self(calls):
    selector = get_selector_from_name("forever_one")
    tx_info = await calls.call_self(selector).call()

    retdata = tx_info.result.retdata

    assert isinstance(retdata, list)
    assert len(retdata) == 1
    assert retdata[0] == 1


@pytest.mark.asyncio
async def test_call_func_single_felt(calls, targets):
    selector = get_selector_from_name("plus_one")
    tx_info = await calls.call_func_single_felt(targets.contract_address, selector).call()

    retdata = tx_info.result.retdata

    assert isinstance(retdata, list)
    assert len(retdata) == 1
    assert retdata[0] == 10


@pytest.mark.asyncio
async def test_call_func_felt_arr(calls, targets):
    selector = get_selector_from_name("sum")
    tx_info = await calls.call_func_felt_arr(targets.contract_address, selector).call()

    retdata = tx_info.result.retdata

    assert isinstance(retdata, list)
    assert len(retdata) == 1
    assert retdata[0] == 1 + 1 + 2 + 3 + 5 + 8  # values hardcoded in the contract (calls.cairo)


@pytest.mark.asyncio
async def test_call_new_phone_who_dis(calls, targets):
    selector = get_selector_from_name("new_phone_who_dis")
    tx_info = await calls.call_func_new_phone_who_dis(targets.contract_address, selector).call()

    retdata = tx_info.result.retdata

    assert isinstance(retdata, list)
    assert len(retdata) == 1
    assert retdata[0] == calls.contract_address


@pytest.mark.asyncio
async def test_call_mint(calls, targets):
    amount = 5000
    await calls.call_mint(targets.contract_address, amount).invoke()

    tx_info = await targets.get_balance(calls.contract_address).call()

    balance = tx_info.result.balance

    assert balance == amount


@pytest.mark.asyncio
async def test_call_mint_to(calls, targets):
    amount = 5000
    addrs = [10, 20, 30]

    # the cairo function is defined as taking 4 arguments, but from python,
    # it has to be invoked with 3 - I guess the array len & pointer calculation is automagic
    await calls.call_mint_to(targets.contract_address, amount, addrs).call()

    for addr in addrs:
        tx_info = await targets.get_balance(addr).call()

        balance = tx_info.result.balance

        assert balance == amount
