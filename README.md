# experiments-in-cairo

A collection of various experiment in using and abusing the [Cairo language](https://www.cairo-lang.org/). I've created the contracts while learning and experimenting with Cairo myself. Most contracts are fully tested. Most work with Cairo v0.6.2, but some require v0.8.0.

## calls.cairo & target.cairo

The code in [`calls.cairo`](./contracts/calls.cairo) and accompanying [`target.cairo`](./contracts/target.cairo) contracts serves to experiment with cross contract invocation (only on Starknet itself, no L1 <-> L2). It employs both the `call_contract` syscall and invoking another contract via an interface, both in a direct fashion and via delegate calls.

## dicts.cairo

[`dicts.cairo`](./contracts/dicts.cairo) has, as the name suggests, functions to do with Cairo's dict module.

## echo.cairo

This contract ([`echo.cairo`](./contracts/echo.cairo)) serves to test what happens when you create an infinite invocation loop. Spoiler alert: the transaction fails.

## enums.cairo

[`enums.cairo`](./contracts/enums.cairo) list different patterns on how to declare an enum in cairo.

## debug_hints.cairo

[`debug_hints.cairo`](./contracts/debug_hints.cairo) shows a super useful way how to use hints for debug purposes. In the test suite, a contract is compiled with `disable_hint_validation=True` which means all hints are fair game. This way, we can add `print` statements at will to ease debugging. All credit goes to [Marcello](https://twitter.com/0xmarcello/status/1491881209240043529) for discovering this technique.

## visibility

The [visibility](./contracts/visibility/) dir hold a simple PoC of unintentional functionality creep. On the surface, the`main.cairo` contract only exposes a single view function. However, because it imports from `library.cairo`, when deployed, these will be compiled and "merged" together. The [deployed contract](https://goerli.voyager.online/contract/0x05e3bf41a8528fa0656b7aea16156a8f53a7064dff372481ce8cc490eb3c05e3#readContract) will also expose `increment` and `get_value` as functions. Furthermore, even though `increment` is marked as a view function, it alters a storage variable 🙈

## state.cairo

The [`state.cairo`](./contracts/state.cairo) contract contains various examples on how to store and model data in Cairo. Warning, not all might be sane 😅

## various.cairo

Random experiments and peculiarities that don't have a place are in [`various.cairo`](./contracts/various.cairo).

## using_invoke.cairo

The [`using_invoke.cairo`](./contracts/using_invoke.cairo) shows how to call a function via a pointer, using `invoke`. It's tricky because it requires non-standard way how to set up implicit arguments via the `ap` pointer.
