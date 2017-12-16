REBOL [
  Title: {Day 15}
  Date: 15-12-2017
]

{!! This one would require REBOL 3 if we wanted to use integer! instead, due to the 32bit signed integer limitation of REBOL 2}
{!! It's also very slow, ~ 3 mins on my computer vs ~ 2 mins for REBOL 3/integer! vs ~ 400 ms for the plain C version}

data: load/all read %data/15.txt ; This is necessary to run correctly on REBOL 3, instead of the usual load %data/15.txt

; --- Part 1 ---
battle: context [
  muls: [16807.0 48271.0] init: use [value] [collect [parse data [2 [to integer! set value integer! (keep to-decimal value)]]]]
  round1: funct [] [
    count: 0 gens: copy init
    loop 40000000 [
      repeat i 2 [
        poke gens i ((muls/:i * gens/:i) // 2147483647.0)
      ]
      all [(gens/1 // 65536.0) == (gens/2 // 65536.0) count: count + 1]
    ]
    count
  ]
  round2: funct [] [
    count: 0 mods: [4.0 8.0] gens: copy init
    loop 5000000 [
      repeat i 2 [
        value: gens/:i
        until [
          value: ((muls/:i * value) // 2147483647.0)
          (value // mods/:i) == 0.0
        ]
        poke gens i value
      ]
      all [(gens/1 // 65536.0) == (gens/2 // 65536.0) count: count + 1]
    ]
    count
  ]
]

r1: battle/round1
print [{Part 1:} r1]

; --- Part 2 ---
r2: battle/round2
print [{Part 2:} r2]
