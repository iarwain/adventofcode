REBOL [
  Title: {Day 16}
  Date: 16-12-2019
]

data: read %data/16.txt

; --- Part 1 ---
fft: context [
  signal: collect [
    use [digit value] [
      digit: charset [#"0" - #"9"]
      parse data [
        some [copy value 1 digit (keep load value)]
      ]
    ]
  ]
  process: funct [] [
    init: [0 1 0 -1] values: signal
    phase: funct [] [
      next-pattern: does [
        all [tail? pattern: next pattern pattern: head pattern]
      ]
      pattern: init
      set 'values collect [
        repeat i length? signal [
          next-pattern
          sum: 0
          foreach value values [
            sum: value * pattern/1 + sum
            next-pattern
          ]
          keep abs sum // 10
          pattern: collect [foreach value init [loop i + 1 [keep value]]]
        ]
      ]
    ]
    loop 100 [
      phase
    ]
    rejoin copy/part values 8
  ]
  decode: funct [] [
    ; Given the triangle nature of the pattern at a given depth, when offset > (0.5 * length? signal), which is the case here,
    ; We only get 1s from the pattern and we can thus simply sum backward on the truncated signal, starting from the end
    offset: load rejoin copy/part signal 7
    full-signal: remove/part head insert/dup copy [] signal 10'000 offset
    loop 100 [
      sums: reduce [first reverse full-signal]
      foreach value next full-signal [
        append sums value + last sums
      ]
      full-signal: reverse collect [
        foreach sum sums [
          keep abs sum // 10
        ]
      ]
    ]
    rejoin copy/part full-signal 8
  ]
]

r1: fft/process
print [{Part 1:} r1]

; --- Part 2 ---
r2: fft/decode
print [{Part 2:} r2]
