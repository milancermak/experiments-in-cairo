%lang starknet

@view
func sum(arr_len : felt, arr : felt*) -> (res : felt):
    tempvar s = 0
    tempvar r = arr_len
    tempvar i = 0

    loop:
    tempvar s = s + [arr + i]
    tempvar r = r - 1
    tempvar i = i + 1
    jmp loop if r != 0

    return (s)
end

# exp_* taken from the Cairo whitepaper, sec. 8.1
# both implementations have the same step count

@view
func exp_recr(x : felt, a : felt, n : felt) -> (res : felt):
    if n == 0:
        return (x)
    end
    return exp_recr(x * a, a, n - 1)
end

@view
func exp_inst(x : felt, a : felt, n : felt) -> (res : felt):
    exp:
    # [fp - 5], [fp - 4], [fp - 3] are x, a, n, respectively.
    jmp body if [fp - 3] != 0
    # n == 0. Return x.
    [ap] = [fp - 5]; ap++
    ret

    body:
    # Return exp(x * a, a, n - 1).
    [ap] = [fp - 5] * [fp - 4]; ap++
    [ap] = [fp - 4]; ap++
    [ap] = [fp - 3] - 1; ap++
    call exp
    ret
end
