REBOL [
  Title: {Day 15}
  Date: 15-12-2017
]

{!! This one requires REBOL 3 due to the 32bit signed integer limitation of REBOL 2}
{!! It's also very slow, ~ 2 mins on my computer}

data: load/all read %data/15.txt

battle: context [
  muls: [16807 48271] init: use [value] [collect [parse data [2 [to integer! set value integer! (keep value)]]]]
  round1: funct [] [
    count: 0 gens: copy init
    loop 40000000 [
      repeat i 2 [
        poke gens i ((muls/:i * gens/:i) // 2147483647)
      ]
      all [(gens/1 // 65536) == (gens/2 // 65536) count: count + 1]
    ]
    count
  ]
  round2: funct [] [
    count: 0 mods: [4 8] gens: copy init
    loop 5000000 [
      repeat i 2 [
        value: gens/:i
        until [
          value: ((muls/:i * value) // 2147483647)
          (value // mods/:i) == 0
        ]
        poke gens i value
      ]
      all [(gens/1 // 65536) == (gens/2 // 65536) count: count + 1]
    ]
    count
  ]
]

; --- Part 1 ---
r1: battle/round1
print [{Part 1:} r1]

; --- Part 2 ---
r2: battle/round2
print [{Part 2:} r2]
