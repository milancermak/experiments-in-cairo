%lang starknet

# some ways how to declare an enum in Cairo

# 1)
# https://hackmd.io/@RoboTeddy/BJZFu56wF#Struct-enum-pattern
struct ChemicalElement:
    member None : felt      # implicitely 0
    member Hydrogen : felt  # 1
    member Helium : felt    # 2
    member Lithium : felt   # 3
    member Beryllium : felt # 4
end

# 2)
# https://twitter.com/PapiniShahar/status/1463114349506142212?s=20
namespace SolarSystem:
    const Sun = 0
    const Mercury = 1
    const Venus = 2
    const Earth = 3
    const Mars = 4
    const Jupiter = 5
    const Saturn = 6
    const Uranus = 7
    const Neptune = 8
    # sorry Pluto
end

# to access members, use
# SolarSystem.Earth
