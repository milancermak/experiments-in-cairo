%lang starknet


@external
func use_random{syscall_ptr : felt*}() -> (rnd : felt):
    alloc_locals
    local rnd

    # because of this hint, the contract won't compile under
    # normal circumstances, but the test suite will run, because
    # I'm using disable_hint_validation=True when compiling
    # contracts for test purposes
    #
    # hints like this are super useful for debugging because
    # you can print variables at will

    %{
    import random
    ids.rnd = random.randint(0, 65535)
    print("rnd is: ", ids.rnd)
    %}

    return (rnd)
end
