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

@pytest.mark.asyncio
async def test_what_caller_address(mocking_internals):
    # just using the caller_address kwarg provided in the invoke
    # function of the testing framework (see StarknetContractFunctionInvocation)
    tx = await mocking_internals.what_caller_address().invoke(caller_address=33)
    assert tx.result.caller_address == 33
