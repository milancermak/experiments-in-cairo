# experiments-in-cairo

A collection of various experiment in using and abusing the [Cairo language](https://www.cairo-lang.org/). I've created the contracts while learning and experimenting with Cairo myself. Most contracts are fully tested. They work with Cairo v0.6.2.

## calls.cairo & target.cairo
The code in [`calls.cairo`](./contracts/calls.cairo) and accompanying [`target.cairo`](./contracts/target.cairo) contracts serves to experiment with cross contract invocation (only on Starknet itself, no L1 <-> L2). It employs both the `call_contract` syscall and invoking another contract via an interface.

## echo.cairo
This contract ([`echo.cairo`](./contracts/echo.cairo)) serves to test what happens when you create an infinite invocation loop. Spoiler alert: the transaction fails.

## enums.cairo
[`enums.cairo`](./contracts/enums.cairo) list different patterns on how to declare an enum in cairo.

## state.cairo
The [`state.cairo`](./contracts/state.cairo) contract contains various examples on how to store and model data in Cairo. Warning, not all might be sane 😅
