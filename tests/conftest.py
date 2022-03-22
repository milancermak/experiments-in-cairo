import asyncio
import os
import pytest

from starkware.starknet.business_logic.state import BlockInfo
from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.services.api.contract_definition import ContractDefinition
from starkware.starknet.testing.starknet import Starknet


def contract_dir() -> str:
    here = os.path.abspath(os.path.dirname(__file__))
    return os.path.join(here, "..", "contracts")


def compile_contract(contract_name: str) -> ContractDefinition:
    contract_src = os.path.join(contract_dir(), contract_name)
    return compile_starknet_files(
        [contract_src], debug_info=True, disable_hint_validation=True, cairo_path=[contract_dir()]
    )


@pytest.fixture(scope="module")
def event_loop():
    return asyncio.new_event_loop()


@pytest.fixture(scope="module")
async def starknet():
    starknet = await Starknet.empty()
    return starknet


@pytest.fixture(scope="module")
async def state(starknet):
    contract = compile_contract("state.cairo")
    return await starknet.deploy(contract_def=contract)


@pytest.fixture(scope="module")
async def calls(starknet):
    contract = compile_contract("calls.cairo")
    return await starknet.deploy(contract_def=contract)


@pytest.fixture(scope="module")
async def targets(starknet):
    contract = compile_contract("targets.cairo")
    return await starknet.deploy(contract_def=contract)


@pytest.fixture(scope="module")
async def echo1(starknet):
    contract = compile_contract("echo.cairo")
    return await starknet.deploy(contract_def=contract)


@pytest.fixture(scope="module")
async def echo2(starknet):
    contract = compile_contract("echo.cairo")
    return await starknet.deploy(contract_def=contract)


@pytest.fixture(scope="module")
async def only_funcs(starknet):
    contract = compile_contract("deeper/only_funcs.cairo")
    return await starknet.deploy(contract_def=contract)


@pytest.fixture(scope="module")
async def debug_hints(starknet):
    contract = compile_contract("debug_hints.cairo")
    return await starknet.deploy(contract_def=contract)


@pytest.fixture(scope="module")
async def various(starknet):
    contract = compile_contract("various.cairo")
    return await starknet.deploy(contract_def=contract)


@pytest.fixture(scope="module")
async def jmp_loop(starknet):
    contract = compile_contract("arr/jmp_loop.cairo")
    return await starknet.deploy(contract_def=contract)

@pytest.fixture(scope="module")
async def mocking_internals(starknet):
    contract = compile_contract("test_mocking_internals.cairo")
    return await starknet.deploy(contract_def=contract)


@pytest.fixture
async def block_info_mock(starknet):
    class Mock:
        def __init__(self, current_block_info):
            self.block_info = current_block_info

        def update(self, block_number, block_timestamp):
            starknet.state.state.block_info = BlockInfo(block_number, block_timestamp)

        def reset(self):
            starknet.state.state.block_info = self.block_info

        def set_block_number(self, block_number):
            starknet.state.state.block_info = BlockInfo(block_number, self.block_info.block_timestamp)

        def set_block_timestamp(self, block_timestamp):
            starknet.state.state.block_info = BlockInfo(self.block_info.block_number, block_timestamp)


    return Mock(starknet.state.state.block_info)
