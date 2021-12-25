# exploring what would happen in a infinite loop on starknet

# deploy this contract twice
# then invoke yell on contract 1 with the address of contract 2 as input
# that will start a loop where, in yell, C1 calls echo on C2, which in turn calls yell on
# C1 (because of get_caller_address) with its own address as input (get_contract_address),
# which then calls echo on C2...

# example (starknet 0.6.2):

# starknet deploy --network alpha-goerli --contract artifacts/echo.json
# Deploy transaction was sent.
# Contract address: 0x0192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0
# Transaction hash: 0x4cd3ec1626b800a77822ebb5f9441ff2f312cfcb72b839d9df8d40810dad8e5

# starknet deploy --network alpha-goerli --contract artifacts/echo.json
# Deploy transaction was sent.
# Contract address: 0x07b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc
# Transaction hash: 0x3827598fbfe3a608862879a97ce2d8898d1e2639e0b0d260daf4c8b73460e9c

# starknet invoke --network alpha-goerli --address 0x0192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0 --abi artifacts/abis/echo.json --function yell --inputs 0x07b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc
# Invoke transaction was sent.
# Contract address: 0x0192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0
# Transaction hash: 0x2fcfeb340d621eaf3da0b133c1302d868074c4bc287d1b0aa11022031e58763

# starknet tx_status --network alpha-goerli --hash 0x2fcfeb340d621eaf3da0b133c1302d868074c4bc287d1b0aa11022031e58763
# {
#     "tx_failure_reason": {
#         "code": "TRANSACTION_FAILED",
#         "error_message": "Error at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:50)\nUnknown location (pc=0:41)\n\nError in the called contract (0x7b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:82)\nUnknown location (pc=0:76)\n\nError in the called contract (0x192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:50)\nUnknown location (pc=0:41)\n\nError in the called contract (0x7b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:82)\nUnknown location (pc=0:76)\n\nError in the called contract (0x192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:50)\nUnknown location (pc=0:41)\n\nError in the called contract (0x7b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:82)\nUnknown location (pc=0:76)\n\nError in the called contract (0x192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:50)\nUnknown location (pc=0:41)\n\nError in the called contract (0x7b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:82)\nUnknown location (pc=0:76)\n\nError in the called contract (0x192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:50)\nUnknown location (pc=0:41)\n\nError in the called contract (0x7b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:82)\nUnknown location (pc=0:76)\n\nError in the called contract (0x192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:50)\nUnknown location (pc=0:41)\n\nError in the called contract (0x7b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:82)\nUnknown location (pc=0:76)\n\nError in the called contract (0x192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:50)\nUnknown location (pc=0:41)\n\nError in the called contract (0x7b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:82)\nUnknown location (pc=0:76)\n\nError in the called contract (0x192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:50)\nUnknown location (pc=0:41)\n\nError in the called contract (0x7b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:82)\nUnknown location (pc=0:76)\n\nError in the called contract (0x192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:50)\nUnknown location (pc=0:41)\n\nError in the called contract (0x7b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:82)\nUnknown location (pc=0:76)\n\nError in the called contract (0x192f29d852d6d3188cdb807eee8f897aa8cc0f4ece428c768ca76c1039499e0):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:50)\nUnknown location (pc=0:41)\n\nError in the called contract (0x7b48c24f3c49a3579a2d6295004036595256796ae25bf74a62155ada0deb5bc):\nError at pc=0:10:\nGot an exception while executing a hint.\nCairo traceback (most recent call last):\nUnknown location (pc=0:82)\nUnknown location (pc=0:76)\n\nError in the called contract (0x192f29",
#         "tx_id": 232679
#     },
#     "tx_status": "REJECTED"
# }

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import (
    call_contract, get_contract_address, get_caller_address)

@external
func yell{syscall_ptr : felt*}(echo_addr : felt):
    alloc_locals

    let (local calldata_ptr : felt*) = alloc()

    # get_selector_from_name("echo") == 301710206996413058962444592991928216677664597027184567149740246420992804240
    call_contract(
        echo_addr,
        301710206996413058962444592991928216677664597027184567149740246420992804240,
        0,
        calldata_ptr)
    return ()
end

@external
func echo{syscall_ptr : felt*}():
    alloc_locals

    let (local calldata_ptr : felt*) = alloc()
    let (self) = get_contract_address()
    assert calldata_ptr[0] = self
    let (them) = get_caller_address()

    # get_selector_from_name("yell") == 1232195082612856881505957543605783642628161810180940877974735618115889387660
    call_contract(
        them,
        1232195082612856881505957543605783642628161810180940877974735618115889387660,
        1,
        calldata_ptr)
    return ()
end
