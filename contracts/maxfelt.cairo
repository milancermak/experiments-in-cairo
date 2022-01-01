%builtins output

from starkware.cairo.common.serialize import serialize_word

func main{output_ptr : felt*}():
    # Cairo field prime is 2**251 + 17 * 2**192 + 1
    # 3618502788666131213697322783095070105623107215331596699973092056135872020481
    #
    # https://www.cairo-lang.org/docs/how_cairo_works/cairo_intro.html
    # https://github.com/starkware-libs/cairo-lang/blob/master/src/starkware/starknet/definitions/constants.py
    #
    # cairo-compile contracts/maxfelt.cairo --output maxfelt.json
    # cairo-run --program=maxfelt.json --print_output --layout=small

    serialize_word(3618502788666131213697322783095070105623107215331596699973092056135872020481 - 1)  # -1
    serialize_word(3618502788666131213697322783095070105623107215331596699973092056135872020481)  # 0
    serialize_word(3618502788666131213697322783095070105623107215331596699973092056135872020481 + 1)  # 1

    return ()
end
