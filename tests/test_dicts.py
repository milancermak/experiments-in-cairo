from collections import defaultdict
import random
import pytest


@pytest.mark.asyncio
async def test_dict_sum_by_keys(dicts):

    keys = []
    values = []
    for _ in range(1_000):
        keys.append(random.randint(0, 30))
        values.append(random.randint(0, 10_000))

    dd = defaultdict(int)
    for k, v in zip(keys, values):
        dd[k] += v

    tx = await dicts.sum_values_by_key(keys, values).invoke()

    as_kv = [(o.key, o.new_value) for o in tx.result.das]
    assert len(as_kv) == len(dd)
    for k, v in as_kv:
        assert dd[k] == v
