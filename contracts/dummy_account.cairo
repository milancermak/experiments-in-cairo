# A dummy account contract without any validations.

# adapted from https://github.com/starkware-libs/cairo-lang/blob/4e233516f52477ad158bc81a86ec2760471c1b65/src/starkware/starknet/core/test_contract/dummy_account.cairo

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import call_contract

@external
func __execute__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        contract_address, selector : felt, calldata_len : felt, calldata : felt*) -> (
        retdata_len : felt, retdata : felt*):
    let (retdata_len : felt, retdata : felt*) = call_contract(
        contract_address=contract_address,
        function_selector=selector,
        calldata_size=calldata_len,
        calldata=calldata)
    return (retdata_len, retdata)
end
