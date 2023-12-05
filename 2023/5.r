REBOL [
  Title: {Day 5}
  Date: 05-12-2023
]

data: split read/string %data/5.txt [newline newline]
seeds: load next find take data {:}
almanac: map-each step data [
  map-each range load next split step newline [
    compose/deep [[(range/2) (range/2 + range/3)] [(range/1) (range/1 + range/3)]]
  ]
]

fertilize: funct [seeds /with-range] [
  all [with-range seeds: map-each [seed range] seeds [reduce [seed seed + range]]]
  foreach step almanac [
    seeds: collect [
      foreach seed seeds [
        foreach range step [
          either with-range [
            if all [
              seed/2 > range/1/1
              range/1/2 > seed/1
            ] [
              inter: reduce [max seed/1 range/1/1 min seed/2 range/1/2]
              all [seed/1 < inter/1 append/only seeds reduce [seed/1 inter/1]]
              all [inter/2 < seed/2 append/only seeds reduce [inter/2 seed/2]]
              seed: reduce [inter/1 + delta: range/2/1 - range/1/1 inter/2 + delta]
              break
            ]
          ] [
            all [
              seed >= range/1/1
              seed <= range/1/2
              seed: range/2/1 + seed - range/1/1
              break
            ]
          ]
        ]
        keep/only seed
      ]
    ]
  ]
  all [with-range seeds: map-each seed seeds [seed/1]]
  first sort seeds
]

; --- Part 1 ---
r1: fertilize seeds
print [{Part 1:} r1]

; --- Part 2 ---
r2: fertilize/with-range seeds
print [{Part 2:} r2]
