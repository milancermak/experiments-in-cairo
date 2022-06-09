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
    let (__fp__, _) = get_fp_and_pc()
    # return (Army.SIZE, cast(&a, felt*))
    return (Army.SIZE, &a)
end

@view
func array_to_army(a_len : felt, a : felt*) -> (a : Army):
    let p : Army* = cast(a, Army*)
    return ([p])
end

#
# ---
#

struct Config:
    member value1 : felt
    member value2 : felt
    member value3 : felt
end

@view
func new_config(value1 : felt, value2 : felt, value3 : felt) -> (config : Config):
    let (c : Config*) = create_new_config(value1, value2, value3)
    return ([c])
end

func create_new_config(v1, v2, v3) -> (config : Config*):
    let (__fp__, _) = get_fp_and_pc()
    return (cast(__fp__ - 2 - Config.SIZE, Config*))
end
