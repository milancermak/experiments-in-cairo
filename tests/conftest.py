import asyncio
import os
import pytest
from starkware.starknet.testing.starknet import Starknet


def contract_path(contract_name: str) -> str:
    here = os.path.abspath(os.path.dirname(__file__))
    return os.path.join(here, "..", "contracts", contract_name)


@pytest.fixture(scope="module")
def event_loop():
    return asyncio.new_event_loop()


@pytest.fixture(scope="module")
async def starknet():
    starknet = await Starknet.empty()
    return starknet


@pytest.fixture(scope="module")
async def state(starknet):
    contract_src = contract_path("state.cairo")
    contract = await starknet.deploy(source=contract_src)
    return contract


@pytest.fixture(scope="module")
async def calls(starknet):
    contract_src = contract_path("calls.cairo")
    contract = await starknet.deploy(source=contract_src)
    return contract


@pytest.fixture(scope="module")
async def targets(starknet):
    contract_src = contract_path("targets.cairo")
    contract = await starknet.deploy(source=contract_src)
    return contract


@pytest.fixture(scope="module")
async def echo1(starknet):
    contract_src = contract_path("echo.cairo")
    contract = await starknet.deploy(source=contract_src)
    return contract


@pytest.fixture(scope="module")
async def echo2(starknet):
    contract_src = contract_path("echo.cairo")
    contract = await starknet.deploy(source=contract_src)
    return contract
