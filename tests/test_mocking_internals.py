import pytest


@pytest.mark.asyncio
async def test_what_block_number(mocking_internals, block_info_mock):
    tx = await mocking_internals.what_block_number().invoke()
    original_block_number = tx.result.block_number

    block_info_mock.set_block_number(20)
    tx = await mocking_internals.what_block_number().invoke()
    assert tx.result.block_number == 20

    block_info_mock.update(30, 1)
    tx = await mocking_internals.what_block_number().invoke()
    assert tx.result.block_number == 30

    block_info_mock.reset()
    tx = await mocking_internals.what_block_number().invoke()
    assert tx.result.block_number == original_block_number


@pytest.mark.asyncio
async def test_what_block_timestamp(mocking_internals, block_info_mock):
    tx = await mocking_internals.what_block_timestamp().invoke()
    original_block_timestamp = tx.result.block_timestamp

    block_info_mock.set_block_timestamp(1_000_000_000)
    tx = await mocking_internals.what_block_timestamp().invoke()
    assert tx.result.block_timestamp == 1_000_000_000

    block_info_mock.update(1, 16)
    tx = await mocking_internals.what_block_timestamp().invoke()
    assert tx.result.block_timestamp == 16

    block_info_mock.reset()
    tx = await mocking_internals.what_block_timestamp().invoke()
    assert tx.result.block_timestamp == original_block_timestamp


# NOTE: there's no way as of yet (cairo-lang 0.8.2.1) to get the gas price
#       in starknet, hence no tests for mocking gas_price


@pytest.mark.asyncio
async def test_what_sequencer_address(mocking_internals, block_info_mock):
    tx = await mocking_internals.what_sequencer_address().invoke()
    original_sequencer_address = tx.result.sequencer_address

    block_info_mock.set_sequencer_address(42)
    tx = await mocking_internals.what_sequencer_address().invoke()
    assert tx.result.sequencer_address == 42

    block_info_mock.reset()
    tx = await mocking_internals.what_sequencer_address().invoke()
    assert original_sequencer_address == tx.result.sequencer_address


@pytest.mark.asyncio
async def test_what_caller_address(mocking_internals):
    # just using the caller_address kwarg provided in the invoke
    # function of the testing framework (see StarknetContractFunctionInvocation)
    tx = await mocking_internals.what_caller_address().invoke(caller_address=33)
    assert tx.result.caller_address == 33
