import pytest

def army_to_list(army):
    return [prop for troop in army for prop in troop]

@pytest.mark.asyncio
async def test_army_to_array(arrstructs):
    troop_vals = (10, 10, 100)
    troops = [arrstructs.Troop(*troop_vals)] * 3
    army = arrstructs.Army(*troops)
    tx = await arrstructs.army_to_array(army).invoke()
    assert tx.result.a == army_to_list(army)


@pytest.mark.asyncio
async def test_array_to_army(arrstructs):
    army = [10, 10, 100, 10, 10, 100, 10, 10, 100]
    tx = await arrstructs.array_to_army(army).invoke()
    assert army_to_list(tx.result.a) == army
