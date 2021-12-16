REBOL [
  Title: {Day 16}
  Date: 16-12-2021
]

; This could probably be rewritten in a shorter form by using parse

data: read %data/16.txt

; --- Part 1 ---
bits: context [
  version: result: expression: 0
  use [sum product minimum maximum greater lesser equal process] [
    sum:      funct [block] [res: 0 foreach entry reduce block [res: res + entry]]
    product:  funct [block] [res: 1 foreach entry reduce block [res: res * entry]]
    minimum:  funct [block] [first minimum-of reduce block]
    maximum:  funct [block] [first maximum-of reduce block]
    greater:  funct [block] [block: reduce block pick [1.0 0.0] block/1 > block/2]
    lesser:   funct [block] [block: reduce block pick [1.0 0.0] block/1 < block/2]
    equal:    funct [block] [block: reduce block pick [1.0 0.0] block/1 = block/2]
    result:   do expression: bind load form collect [
      do process: funct [data] [
        read-16: funct [data digits] [to-integer debase/base head insert/dup take/part data digits #"0" 16 - digits 2]
        set 'version version + read-16 data 3
        either 4 = id: read-16 data 3 [
          insert/dup value: rejoin collect [until [keep next val: take/part data 5 val/1 = #"0"]] {0} 64 - length? value
          ; Manually converting 64bit int to decimal
          number: 0.0 keep loop 4 [number: number * 65536 + read-16 value 16]
        ] [
          keep pick [sum product minimum maximum none greater lesser equal] id + 1
          keep {[}
          either #"0" = take data [
            data: take/part data read-16 data 15
            until [process data empty? data]
          ] [
            loop read-16 data 11 [process data]
          ]
          keep {]}
        ]
      ] enbase/base debase/base data 16 2
    ] 'sum
    result: copy/part result: to-string result find result {.}
  ]
]

r1: bits/version
print [{Part 1:} r1]

; --- Part 2 ---
r2: bits/result
print [{Part 2:} r2]
