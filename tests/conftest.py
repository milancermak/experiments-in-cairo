import asyncio
import os
import pytest

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
