import pytest

from starkware.starknet.public.abi import get_selector_from_name


@pytest.mark.asyncio
async def test_call_self(calls):
    selector = get_selector_from_name("forever_one")
    tx_info = await calls.call_self(selector).invoke()

    retdata = tx_info.result.retdata

    assert isinstance(retdata, list)
    assert len(retdata) == 1
    assert retdata[0] == 1


@pytest.mark.asyncio
async def test_call_func_single_felt(calls, targets):
    selector = get_selector_from_name("plus_one")
    tx_info = await calls.call_func_single_felt(targets.contract_address, selector).invoke()

    retdata = tx_info.result.retdata

    assert isinstance(retdata, list)
    assert len(retdata) == 1
    assert retdata[0] == 10


@pytest.mark.asyncio
async def test_call_func_felt_arr(calls, targets):
    selector = get_selector_from_name("sum")
    tx_info = await calls.call_func_felt_arr(targets.contract_address, selector).invoke()

    retdata = tx_info.result.retdata

    assert isinstance(retdata, list)
    assert len(retdata) == 1
    assert retdata[0] == 1 + 1 + 2 + 3 + 5 + 8  # values hardcoded in the contract (calls.cairo)


@pytest.mark.asyncio
async def test_call_new_phone_who_dis(calls, targets):
    selector = get_selector_from_name("new_phone_who_dis")
    tx_info = await calls.call_func_new_phone_who_dis(targets.contract_address, selector).invoke()

    retdata = tx_info.result.retdata

    assert isinstance(retdata, list)
    assert len(retdata) == 1
    assert retdata[0] == calls.contract_address


@pytest.mark.asyncio
async def test_call_mint(calls, targets):
    amount = 5000
    await calls.call_mint(targets.contract_address, amount).invoke()

    tx_info = await targets.get_balance(calls.contract_address).invoke()

    balance = tx_info.result.balance

    assert balance == amount


@pytest.mark.asyncio
async def test_call_mint_to(calls, targets):
    amount = 5000
    addrs = [10, 20, 30]

    # the cairo function is defined as taking 4 arguments, but from python,
    # it has to be invoked with 3 - I guess the array len & pointer calculation is automagic
    await calls.call_mint_to(targets.contract_address, amount, addrs).invoke()

    for addr in addrs:
        tx_info = await targets.get_balance(addr).invoke()

        balance = tx_info.result.balance

        assert balance == amount


@pytest.mark.asyncio
async def test_calling_methods(calls, targets, account_contract):
    # print()
    # print(account_contract.contract_address)
    # print(calls.contract_address)
    # print(targets.contract_address)

    # via call_contract
    exec_selector = get_selector_from_name("cc_via_call_contract")
    target_selector = get_selector_from_name("get_caller_and_contract")

    tx = await account_contract.__execute__(
        calls.contract_address, exec_selector, [targets.contract_address, target_selector]
    ).invoke()
    this_caller, this_contract, that_caller, that_contract = tx.result.retdata

    assert this_caller == account_contract.contract_address
    assert that_caller == calls.contract_address
    assert this_contract == calls.contract_address
    assert that_contract == targets.contract_address

    # via delegate_call
    exec_selector = get_selector_from_name("cc_via_delegate_call")
    tx = await account_contract.__execute__(
        calls.contract_address, exec_selector, [targets.contract_address, target_selector]
    ).invoke()
    this_caller, this_contract, that_caller, that_contract = tx.result.retdata

    assert this_caller == account_contract.contract_address
    assert that_caller == account_contract.contract_address
    assert this_contract == calls.contract_address
    assert that_contract == calls.contract_address

    # via interface direct
    exec_selector = get_selector_from_name("cc_via_interface_direct")
    tx = await account_contract.__execute__(
        calls.contract_address, exec_selector, [targets.contract_address]
    ).invoke()
    this_caller, this_contract, that_caller, that_contract = tx.result.retdata

    assert this_caller == account_contract.contract_address
    assert that_caller == calls.contract_address
    assert this_contract == calls.contract_address
    assert that_contract == targets.contract_address

    # via interface delegate
    exec_selector = get_selector_from_name("cc_via_interface_delegate")
    tx = await account_contract.__execute__(
        calls.contract_address, exec_selector, [targets.contract_address]
    ).invoke()
    this_caller, this_contract, that_caller, that_contract = tx.result.retdata

    assert this_caller == account_contract.contract_address
    assert that_caller == account_contract.contract_address
    assert this_contract == calls.contract_address
    assert that_contract == calls.contract_address
