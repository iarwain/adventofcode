REBOL [
  Title: {Day 5}
  Date: 05-12-2023
]

data: split read/string %data/5.txt [newline newline]
seeds: load next find take data {:}
almanac: map-each step data [
  map-each range load next split step newline [
    context [
      from: context [begin: range/2 end: range/2 + range/3]
      to: context [begin: range/1 end: range/1 + range/3]
    ]
  ]
]

fertilize: funct [seeds /with-range] [
  all [with-range seeds: map-each [seed range] seeds [context [begin: seed end: seed + range]]]
  foreach step almanac [
    seeds: collect [
      foreach seed seeds [
        foreach range step [
          either with-range [
            if all [
              seed/end > range/from/begin
              range/from/end > seed/begin
            ] [
              inter: reduce [max seed/begin range/from/begin min seed/end range/from/end]
              all [seed/begin < inter/1 append/only seeds context [begin: seed/begin end: inter/1]]
              all [inter/2 < seed/end append/only seeds context [begin: inter/2 end: seed/end]]
              seed: context [begin: inter/1 + delta: range/to/begin - range/from/begin end: inter/2 + delta]
              break
            ]
          ] [
            all [
              seed >= range/from/begin
              seed <= range/from/end
              seed: range/to/begin + seed - range/from/begin
              break
            ]
          ]
        ]
        keep/only seed
      ]
    ]
  ]
  all [with-range seeds: map-each seed seeds [seed/begin]]
  first sort seeds
]

; --- Part 1 ---
r1: fertilize seeds
print [{Part 1:} r1]

; --- Part 2 ---
r2: fertilize/with-range seeds
print [{Part 2:} r2]
