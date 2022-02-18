# experiments-in-cairo

A collection of various experiment in using and abusing the [Cairo language](https://www.cairo-lang.org/). I've created the contracts while learning and experimenting with Cairo myself. Most contracts are fully tested. They work with Cairo v0.6.2.

## calls.cairo & target.cairo

The code in [`calls.cairo`](./contracts/calls.cairo) and accompanying [`target.cairo`](./contracts/target.cairo) contracts serves to experiment with cross contract invocation (only on Starknet itself, no L1 <-> L2). It employs both the `call_contract` syscall and invoking another contract via an interface.

## echo.cairo

This contract ([`echo.cairo`](./contracts/echo.cairo)) serves to test what happens when you create an infinite invocation loop. Spoiler alert: the transaction fails.

## enums.cairo

[`enums.cairo`](./contracts/enums.cairo) list different patterns on how to declare an enum in cairo.

## debug_hints.cairo

[`debug_hints.cairo](./contracts/debug_hints.cairo) shows a super useful way how to use hints for debug purposes. In the test suite, a contract is compiled with `disable_hint_validation=True` which means all hints are fair game. This way, we can add `print` statements at will to ease debugging. All credit goes to [Marcello](https://twitter.com/0xmarcello/status/1491881209240043529) for discovering this technique.

## state.cairo

The [`state.cairo`](./contracts/state.cairo) contract contains various examples on how to store and model data in Cairo. Warning, not all might be sane 😅

## various.cairo

Random experiments and peculiarities that don't have a place are in [`various.cairo`](./contracts/various.cairo).
