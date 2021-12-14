REBOL [
  Title: {Day 14}
  Date: 14-12-2021
]

data: read/lines %data/14.txt

; --- Part 1 ---
polymer: context [
  process: none
  use [template rules] [
    template: take data rules: make hash! collect [
      foreach entry next data [rule: parse entry {->} keep reduce [rule/1 rule/3]]
    ]
    process: funct [steps] [
      pairs: make hash! [] it: next template
      forall it [either find pairs pair: copy/part back it 2 [pairs/:pair: pairs/:pair + 1] [insert pairs reduce [pair 1.0]]]
      loop steps [
        new-pairs: make hash! []
        foreach [pair value] pairs [
          foreach pair reduce [rejoin [pair/1 rules/:pair] rejoin [rules/:pair pair/2]] [
            either find new-pairs pair [new-pairs/:pair: new-pairs/:pair + value] [insert new-pairs reduce [pair value]]
          ]
        ]
        pairs: new-pairs
      ]
      count: array/initial 2 []
      foreach [key value] pairs [
        repeat i 2 [
          either find count/:i key/:i [count/:i/(key/:i): count/:i/(key/:i) + value] [insert count/:i reduce [key/:i value]]
        ]
      ]
      count: map-each key unique union extract count/1 2 extract count/2 2 [max count/1/:key count/2/:key]
      copy/part result: to-string (first maximum-of count) - (first minimum-of count) find result {.}
    ]
  ]
]

r1: polymer/process 10
print [{Part 2:} r1]

; --- Part 2 ---
r2: polymer/process 40
print [{Part 2:} r2]
