%lang starknet

from starkware.cairo.lang.compiler.lib.registers import get_fp_and_pc

struct Troop:
    member attack : felt
    member defense : felt
    member health : felt
end

struct Army:
    member troop1 : Troop
    member troop2 : Troop
    member troop3 : Troop
end

@view
func army_to_array(a : Army) -> (a_len : felt, a : felt*):
    let (fp_val, _) = get_fp_and_pc()
    return (Army.SIZE, cast(fp_val - 2 - Army.SIZE, felt*))
end

@view
func array_to_army(a_len : felt, a : felt*) -> (a : Army):
    let p : Army* = cast(a, Army*)
    return ([p])
end
