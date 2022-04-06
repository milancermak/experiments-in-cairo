%lang starknet

from starkware.cairo.common.dict import dict_read, dict_write
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize

# function takes a list of keys (e.g. token IDs) which can repeat
# and a list of values (e.g. amount of tokens) and returns a list of
# unique keys and a list of summed values for each key
# input:  [1, 3, 7, 7, 2, 7, 4, 1], [10, 10, 10, 10, 10, 10, 10, 10]
# output: [(1, 0, 20), (2, 0, 10), (3, 0, 10), (4, 0, 10), (7, 0, 30)]
# the output is a list of DictAccess tuples, which is quite easily
# convertible further

@view
func sum_values_by_key{range_check_ptr}(
        keys_len : felt, keys : felt*, values_len : felt, values : felt*) -> (
        das_len : felt, das : DictAccess*):
    alloc_locals

    with_attr error_message("keys and values arrays must be of same length"):
        if keys_len != values_len:
            assert 1 = 0
        end
    end

    let (local dict_start : DictAccess*) = default_dict_new(default_value=0)

    let (dict_end : DictAccess*) = sum_values_by_key_loop(dict_start, keys_len, keys, values)

    let (finalized_dict_start, finalized_dict_end) = default_dict_finalize(dict_start, dict_end, 0)

    # figure out the size of the dict, because it's needed to return an array of DictAccess objects
    let ptr_diff = [ap]
    ptr_diff = finalized_dict_end - finalized_dict_start; ap++
    tempvar unique_keys = ptr_diff / DictAccess.SIZE

    return (unique_keys, finalized_dict_start)
end

func sum_values_by_key_loop{range_check_ptr}(
        dict : DictAccess*, len : felt, keys : felt*, values : felt*) -> (
        dict_end : DictAccess*):
    alloc_locals

    if len == 0:
        return (dict)
    end

    let (current : felt) = dict_read{dict_ptr=dict}(key=[keys])
    let updated = current + [values]
    dict_write{dict_ptr=dict}(key=[keys], new_value=updated)

    return sum_values_by_key_loop(dict, len - 1, keys + 1, values + 1)
end
